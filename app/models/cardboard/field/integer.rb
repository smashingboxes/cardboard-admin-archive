module Cardboard
  class Field::Integer < Field
    validate :is_integer
    validate :is_required


    def value=(val)
      self.value_uid = val == "" ? nil : val #bug in rails? should work with allow_blank
    end

    def value
      self.value_uid.to_i
    end

    def default
      12321454
    end

  private

    def is_integer
      errors.add(:value, "is not a number") if value_uid.present? && value_uid.to_s =~ /[^\d]/
    end

  end
end