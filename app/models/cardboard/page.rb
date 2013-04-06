module Cardboard
  class Page < ActiveRecord::Base
    attr_accessible :position, :title, :path, :slug, :parent_id
    attr_accessor :parent_id
    serialize :meta_seo, Hash

    has_many :parts, class_name: "PagePart"
    has_many :fields, :through => :parts
    

    #gems
    acts_as_url :title, :url_attribute => :slug, :scope =>  :path, only_when_blank: true

    include RankedModel
    ranks :position, :with_same => :path

    #validations
    validates :title, :path, presence:true
    validates :slug, uniqueness: { :case_sensitive => false, :scope => :path }
    validates :identifier, uniqueness: {:case_sensitive => false}
    #validate all seo keys are valid meta keys + title

    #scopes
    scope :preordered, order("path DESC, position ASC, slug DESC")


    #overwritten setters/getters
    def slug=(value)
      # the user can overwrite the auto generated slug
      self[:slug] = value.present? ? value.to_url : nil
    end


    #class methods
    def self.find_by_url(full_url)
      full_url = full_url.split("/")
      slug = full_url.pop
      path = full_url.join("/") + "/"
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

    def seo(tag)
      # if Cardboard::Setting.inherit_seo
        @seo ||= {}
        @seo[tag.to_s] ||= (meta_seo[tag.to_sym] || self.parent.try{|page| page.meta_seo[tag.to_sym]})
      # else
      #   meta_seo[tag.to_sym]
      # end
    end
    
    def url
      return "/" if slug.blank?
      "#{path}#{slug}/"
    end

    def parent
      Cardboard::Page.find_by_url(path)
    end

    def parent=(new_parent)
      self.path = new_parent ? new_parent.url : "/"
    end

    def parent_id=(new_parent_id)
      self.parent = Cardboard::Page.where(id: new_parent_id).first
    end

    def children
      Cardboard::Page.where(path: url)
    end

    def siblings
      Cardboard::Page.where("path = ? AND id != ?", path, id)
    end

    def depth
      # root is depth 0
      url.split("/").size
    end
  end
end
