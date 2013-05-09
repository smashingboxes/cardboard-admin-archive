module Cardboard
  class Field::Decimal < Field
    validates :value, :numericality  => { :only_integer => false}, :allow_blank => true
    validates :value, presence:true, :if => :required_field?

    def value=(val)
      self.value = nil if value == "" #bug in rails?
      super
    end

    def value
      super.to_f
    end

    def default
      234.23
    end

  end
end