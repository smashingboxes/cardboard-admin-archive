module Cardboard
  class Field < ActiveRecord::Base
    belongs_to :group, class_name: "FieldGroup"

    attr_accessible :display_name, :element_name, :position, :required, :type, :value

    #gem
    ranks :position, :with_same => :field_group_id

    #validations
    validates :name, :type, presence:true

    #overwritten setter
    def type=(value)
      self[:type] = "Field::#{value.camelize}"
    end
  end
end
