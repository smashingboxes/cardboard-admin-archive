module Cardboard
  class PagePart < ActiveRecord::Base
    self.set_table_name "cardboard_page_parts"
    has_many :fields, class_name: "Cardboard::Field", :dependent => :destroy, :validate => true, :foreign_key => "page_part_id"
    # belongs_to :page
    has_many :children, class_name: "Cardboard::PagePart", :dependent => :destroy
    belongs_to :parent, class_name: "Cardboard::PagePart"

    attr_accessible :position, :allow_multiple, :label, :children_attributes, :fields_attributes
    accepts_nested_attributes_for :children, :allow_destroy => true, :reject_if => :all_blank
    accepts_nested_attributes_for :fields, :allow_destroy => true, :reject_if => :all_blank

    validates :identifier, uniqueness: {:case_sensitive => false, :scope => :page_id}, :format => { :with => /\A[a-z\_0-9]+\z/,
    :message => "Only downcase letters, numbers and underscores are allowed" }
  end
end
