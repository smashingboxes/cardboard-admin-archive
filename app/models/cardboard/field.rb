module Cardboard
  class Field < ActiveRecord::Base
    self.set_table_name "cardboard_fields"
    belongs_to :part, class_name: "Cardboard::PagePart", :foreign_key => "page_part_id"

    attr_accessible :label, :position, :required, :type, :value, :hint, :placeholder
    alias_attribute :value, :value_uid # workaround for dragonfly (make sure to use super to overwrite value)

    #gem
    include RankedModel
    ranks :position, :with_same => :page_part_id

    #validations
    validates :identifier, :type, presence:true
    validates :identifier, uniqueness: {:case_sensitive => false, :scope => :page_part_id}, :format => { :with => /\A[a-z\_0-9]+\z/,
    :message => "Only downcase letters, numbers and underscores are allowed" }

    # overwritten setter
    def type=(val)
      return super if val =~ /^Cardboard::Field::/ || val.nil?
      self[:type] = "Cardboard::Field::#{val.to_s.camelize}"
    end

    def type
      self[:type].demodulize.underscore
    end

  end
end
