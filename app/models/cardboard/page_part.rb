module Cardboard
  class PagePart < ActiveRecord::Base
    has_many :fields, :as => :object_with_field, class_name: "Cardboard::Field", :dependent => :destroy, :inverse_of => :object_with_field

    belongs_to :page

    accepts_nested_attributes_for :fields #, :allow_destroy => true (maybe for super admin?)

    validates :identifier, :format => {:with => /\A[a-z\_0-9]+\z/, :message => "Only downcase letters, numbers and underscores are allowed"} # uniqueness: {:case_sensitive => false, :scope => :page_id}, 
    validates :page, :identifier, presence: true                  
    validates_associated :fields


    #gem
    include RankedModel
    ranks :part_position, :with_same => :page_id, :column => :position
    default_scope {order("position ASC")}


    def repeatable?
       @repeatable ||= self.page.template.fields[self.identifier][:repeatable]
    end

    def template
      @template ||= self.page.template_hash[self.identifier][:fields]
    end

    def attr(field)
      field = field.to_s
      @attr ||= {}
      @attr[field] ||= begin
        f = self.fields.where(identifier: field).first
        return nil unless f
        out = f.value_uid.nil? ? nil : f.value
        out = f.default if f.required? && out.nil?
        out
      end
    end

    
  end
end