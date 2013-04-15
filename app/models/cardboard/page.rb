module Cardboard
  class Page < ActiveRecord::Base
    self.set_table_name "cardboard_pages"

    has_many :parts, class_name: "Cardboard::PagePart", :dependent => :destroy, :validate => true
    # has_many :fields, :through => :parts, class_name: "Cardboard::Field"
      
    attr_accessible :position, :title, :path, :slug, :parent_id, :parts_attributes, :meta_seo, :in_menu
    attr_accessor :parent_url
    accepts_nested_attributes_for :parts, allow_destroy: true, :reject_if => :all_blank
    serialize :meta_seo, Hash

    before_validation :default_values

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
      where(path: path, slug: slug).first
    end

    def self.root
      # Homepage is the highest position in the root path
      where(path: "/").rank(:position).first
    end
    def self.homepage; self.root; end

    #instance methods

    # @page.get("slideshow.image")
    # def get(field)
    #   #get value for a field name (document attributes take precedence (example:title))
    #   out = self.fields_value[field.to_s]
    #   return out.blank? ? self[field.to_sym] : out
    # end

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
      Cardboard::Page.find_by_url(path)
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
      @arrange ||= begin
        pages ||= self.preordered.all

        pages.inject(ActiveSupport::OrderedHash.new) do |ordered_hash, page|
          (["/"] + page.split_path).inject(ordered_hash) do |insertion_hash, subpath|
            
            insertion_hash.each do |parent, children|
              # binding.pry if subpath == parent.slug
              insertion_hash = children if subpath == parent.slug
            end
            insertion_hash
          end[page] = ActiveSupport::OrderedHash.new
          ordered_hash
        end
      end
    end   

  private

    def default_values
      self.path  ||= '/'
      self.title ||= self.identifier.parameterize("_")
    end
  end
end
