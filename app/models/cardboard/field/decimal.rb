module Cardboard
  class Field::Decimal < Field
    # validates :value, :numericality  => { :only_integer => false}, :allow_blank => true
    # validates :value, presence:true, :if => :required_field?
    validate :is_decimal

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
      if required_field? && value_uid.blank?
        errors.add(:value, "is required") 
      elsif value_uid.to_s =~ /([^\d\.]|\.{2,})/
        errors.add(:value, "is not a number")
      end
    end

  end
end