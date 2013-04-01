module Cardboard
  class Field::Number < Field
    validates :value, :numericality  => { :only_integer => true }

    def value
      self[:value].to_i
    end
  end
end