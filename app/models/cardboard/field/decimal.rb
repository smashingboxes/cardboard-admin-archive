module Cardboard
  class Field::Decimal < Field
    validates :value, :numericality  => { :only_integer => false}, :allow_blank => true
    validates :value, presence:true, :if => :required_field?

    def value=(val)
      super value == "" ? nil : val #bug in rails? should work with allow_blank
    end

    def value
      super.to_f
    end

    def default
      234.23
    end

  end
end