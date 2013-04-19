module Cardboard
  class Field::Date < Field

    def value
      Chronic.parse(super)
    end

    def default
      Time.now
    end
  end
end