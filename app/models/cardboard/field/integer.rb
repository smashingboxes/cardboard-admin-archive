module Cardboard
  class Field::Integer < Field
    validates :value, :numericality  => { :only_integer => true }, :allow_nil => true

    def value
      super.to_i
    end
  end
end