module Cardboard
  class Field < ActiveRecord::Base
    self.set_table_name "cardboard_fields"
    belongs_to :part, class_name: "PagePart"

    attr_accessible :label, :position, :required, :type, :value, :hint, :placeholder
    alias_attribute :value, :value_uid # workaround for dragonfly (make sure to use super to overwrite value)

    #gem
    include RankedModel
    ranks :position, :with_same => :part_id

    #validations
    validates :identifier, :type, presence:true

    #overwritten setter
    def type=(val)
      return nil unless val
      self[:type] = "Field::#{val.to_s.camelize}"
    end



  end
end
