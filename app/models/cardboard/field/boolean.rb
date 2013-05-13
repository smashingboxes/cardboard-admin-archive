module Cardboard
  class Field::Boolean < Field
    validate :is_boolean?

    def value
      value_uid.to_s.to_boolean
    end

    def value=(val)
      self.value_uid = val
    end

    def default
      [true, false].sample
    end

    private

    def is_required
      # don't check (since nil or blank == false)
    end

    def is_boolean?
      self.value rescue errors.add(:value, "is not a valid boolean")
    end
  end
end