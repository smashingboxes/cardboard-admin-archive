module Cardboard
  class Field::Decimal < Field

    def value
      super.to_f
    end
  end
end