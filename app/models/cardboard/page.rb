module Cardboard
  class Page < ActiveRecord::Base
    self.set_table_name "cardboard_pages"

    has_many :parts, class_name: "Cardboard::PagePart", :dependent => :destroy, :validate => true
    # has_many :fields, :through => :parts, class_name: "Cardboard::Field"
      
    attr_accessible :position, :title, :path, :slug, :parent_id, :parts_attributes, :meta_seo, :in_menu
    attr_accessor :parent_url
    accepts_nested_attributes_for :parts, allow_destroy: true, :reject_if => :all_blank
    serialize :meta_seo, Hash
    serialize :slugs_backup, Array

    before_validation :default_values
    before_save :update_slugs_backup

    #gems
    acts_as_url :title, :url_attribute => :slug, :scope =>  :path, only_when_blank: true

    include RankedModel
    ranks :position, :with_same => :path

    #validations
    validates :title, :path, presence:true
    validates :slug, uniqueness: { :case_sensitive => false, :scope => :path }
    validates :identifier, uniqueness: {:case_sensitive => false}, :format => { :with => /\A[a-z\_0-9]+\z/,
    :message => "Only downcase letters, numbers and underscores are allowed" }
    #validate all seo keys are valid meta keys + title
    validates_associated :parts

    #scopes
    scope :preordered, order("path ASC, position ASC, slug ASC") #order("CASE slug WHEN '/' THEN 'slug, position' ELSE 'path, position, slug' END")


    #overwritten setters/getters
    def slug=(value)
      # the user can overwrite the auto generated slug
      self[:slug] = value.present? ? value.to_url : nil
    end

    #class methods
    def self.find_by_url(full_url)
      full_url = full_url.sub(/^\//,'').split("/")
      slug = full_url.pop
      path = full_url.blank? ? "/" : "/#{full_url.join("/")}/"
      page = self.where(path: path, slug: slug).first
      page = self.where(path: path).where("slugs_backup ILIKE ?", "% #{slug}\n%").first if page.nil?
      return page
    end

    def self.root
      # Homepage is the highest position in the root path
      where(path: "/").rank(:position).first
    end
    def self.homepage; self.root; end

    #instance methods

    # @page.get("slideshow.image1")
    # @page.get("slideshow").first.image1
    # @page.get("slideshow").each...

    # slideshow = @page.get("slideshow")
    # slideshow.field("image1")
    # slideshow.each{|p| p.field("image")}
    # slideshow.get("slide1")
    def get(field)
      f = field.split(".")
      part = self.parts.where(identifier: f.first)
      return part if f.size == 1
      part.first.send(f.last)
    end

    # SEO
    # children inherit their parent's SEO settings (these can be overwritten)
    def seo
      parent ? parent.seo.merge(meta_seo) : meta_seo
    end
    def seo=(hash); self.meta_seo = hash; end
    
    def url
      return "/" if slug.blank?
      "#{path}#{slug}/"
    end

    def split_path
      path.sub(/^\//,'').split("/") # "/path/" => ["path"]
    end

    def parent
      @parent ||= Cardboard::Page.find_by_url(path)
    end

    # Get all other pages
    def parent_url_options
      Cardboard::Page.all.inject(["/"]) do |result, elm| 
        result << elm.url unless elm.id == self.id
        result
      end.sort
    end

    def parent_url
      return "/" if parent.nil?
      parent.url
    end

    def parent=(new_parent)
      return nil if new_parent && !new_parent.is_a?(Cardboard::Page) 
      self.path = new_parent ? new_parent.url : "/"
    end

    def parent_id=(new_parent_id)
      self.parent = Cardboard::Page.where(identifier: new_parent_id).first
    end

    def parent_url=(new_parent_url)
      self.parent = Cardboard::Page.find_by_url(new_parent_url)
    end

    def children
      Cardboard::Page.where(path: url)
    end

    def siblings
      Cardboard::Page.where("path = ? AND id != ?", path, id)
    end

    def depth
      # root is depth 0
      split_path.size
    end

    # Arrange array of nodes into a nested hash of the form 
    # {node => children}, where children = {} if the node has no children
    #
    # Example:
    # {#<Cardboard::Page => {
    #    #<Cardboard::Page => {}
    #    #<Cardboard::Page => {}
    #    #<Cardboard::Page => {#<Cardboard::Page => {}}
    # }}
    def self.arrange(pages = nil)
      pages ||= self.preordered.all

      pages.inject(ActiveSupport::OrderedHash.new) do |ordered_hash, page|
        (["/"] + page.split_path).inject(ordered_hash) do |insertion_hash, subpath|
          
          insertion_hash.each do |parent, children|
            insertion_hash = children if subpath == parent.slug
          end
          insertion_hash
        end[page] = ActiveSupport::OrderedHash.new
        ordered_hash
      end
    end   

  private

    def update_slugs_backup
      return nil if !self.slug_changed? || self.slug_was.nil?
      self.slugs_backup |= [self.slug_was] #Yes, that's a single pipe...
    end

    def default_values
      self.path  ||= '/'
      self.title ||= self.identifier.parameterize("_")
    end
  end
end
