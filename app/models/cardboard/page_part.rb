module Cardboard
  class PagePart < ActiveRecord::Base
    self.set_table_name "cardboard_page_parts"
    has_many :fields
    belongs_to :page
    has_many :children, class_name: "PagePart"
    belongs_to :parent, class_name: "PagePart"

    attr_accessible :position, :allow_multiple, :label, :children_attributes, :fields_attributes
    accepts_nested_attributes_for :children, :allow_destroy => true
    accepts_nested_attributes_for :fields, :allow_destroy => true

  end
end
