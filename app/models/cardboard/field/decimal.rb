module Cardboard
  class Field::Decimal < Field

    def value
      super.to_f
    end

    def default
      234.23
    end

  end
end