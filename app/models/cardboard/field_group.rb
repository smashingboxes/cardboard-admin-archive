module Cardboard
  class FieldGroup < ActiveRecord::Base
    attr_accessible :editable_form_id, :editable_form_type, :name
    has_many :fields
    belongs_to :editable_form, :polymorphic => true
    #gem
    ranks :position, :with_same => :field_group_id
  end
end
