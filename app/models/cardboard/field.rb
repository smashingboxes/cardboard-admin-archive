module Cardboard
  class Field < ActiveRecord::Base
    attr_accessor :seeding, :default
    alias_attribute :value, :value_uid

    belongs_to :object_with_field, :polymorphic => true, :inverse_of => :fields

    attr_accessible :position, :value #, :value_uid

    #gem
    include RankedModel
    ranks :position, :with_same => :object_with_field_id

    #validations
    validates :identifier, :type, presence:true
    validates :identifier, uniqueness: {:case_sensitive => false, :scope => [:object_with_field_id, :object_with_field_type]}, 
                          :format => { :with => /\A[a-z\_0-9]+\z/,
                          :message => "Only downcase letters, numbers and underscores are allowed" }

    default_scope rank(:position)

    # overwritten setter
    def type=(val)
      return super if val =~ /^Cardboard::Field::/ || val.nil?
      self[:type] = "Cardboard::Field::#{val.to_s.camelize}"
    end
    def type
      @friendly_type ||= self[:type].demodulize.underscore
    end

    def default
      #overwritten for each subclass
    end
    def default=(val)
      self.value_uid = val if self.value_uid.nil? && val.present?
    end

  private

    def is_required
      errors.add(:value, "is required") if required_field? && value_uid.blank?
    end
    
    def required_field?
      self.required? && !self.new_record? && !self.seeding
    end

  end
end
