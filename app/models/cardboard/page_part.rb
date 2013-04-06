module Cardboard
  class PagePart < ActiveRecord::Base
    attr_accessible :identifier, :position, :allow_multiple, :label
    has_many :fields
    belongs_to :page
    has_many :children, class_name: "PagePart"
    belongs_to :parent, class_name: "PagePart"

  end
end
