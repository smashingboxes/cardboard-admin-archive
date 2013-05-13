module Cardboard
  class Field::Decimal < Field
    validate :is_decimal
    validate :is_required

    def value=(val)
      self.value_uid = val == "" ? nil : val #bug in rails? should work with allow_blank
    end

    def value
      value_uid.to_f
    end

    def default
      234.23
    end

    private

    def is_decimal
      errors.add(:value, "is not a number") if value_uid.present? && value_uid.to_s =~ /([^\d\.]|\.{2,})/
    end

  end
end