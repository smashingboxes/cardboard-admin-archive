module Cardboard
  class Field::Boolean < Field
    before_validation :convert_to_boolean

    validate :is_boolean
    

    def default
      [true, false].sample
    end

    private

    def is_boolean
      errors.add(:value, "is not a valid boolean") if self.value.nil?
    end

    def convert_to_boolean
      self.value = to_boolean(self.value_uid)
      true # don't return a validation error on false
    end

    def to_boolean(val)
      return true if val == true || !!(val =~ /(true|t|yes|y|1)$/i)
      return false if val == false || val.blank? || !!(val =~ /(false|f|no|n|0)$/i)
      return nil
    end
  end
end