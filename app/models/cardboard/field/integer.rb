module Cardboard
  class Field::Integer < Field
    # validates :value, :numericality  => { :only_integer => true }, :allow_blank => true
    # validates :value, presence:true, :if => :required_field?
    validate :is_integer

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
      if required_field? && value_uid.blank?
        errors.add(:value, "is required") 
      elsif value_uid.to_s =~ /[^\d]/
        errors.add(:value, "is not a number")
      end
    end

  end
end