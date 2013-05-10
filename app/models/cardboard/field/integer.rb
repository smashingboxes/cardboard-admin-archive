module Cardboard
  class Field::Integer < Field
    validates :value, :numericality  => { :only_integer => true }, :allow_blank => true
    validates :value, presence:true, :if => :required_field?

    def value=(val)
      super val.to_i
    end

    def value
      super.to_i
    end

    def default
      12321454
    end
  end
end