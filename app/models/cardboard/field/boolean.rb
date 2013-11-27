module Cardboard
  class Field::Boolean < Field
    validate :is_boolean?

    def value=(val)
      self.value_uid = to_boolean(val)
    end

    def default
      [true, false].sample
    end

    private

    def is_required
      # don't check (since nil or blank == false)
    end

    def is_boolean?
      errors.add(:value, "is not a valid boolean") if self.value_uid.nil?
    end

    private

    def to_boolean(val)
      return true if val == true || !!(val =~ /(true|t|yes|y|1)$/i)
      return false if val == false || val.blank? || !!(val =~ /(false|f|no|n|0)$/i)
      return nil
    end
  end
end