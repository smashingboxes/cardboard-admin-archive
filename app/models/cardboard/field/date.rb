module Cardboard
  class Field::Date < Field
    validates :value, presence:true, :if => :required_field?

    def value
      Chronic.parse(super)
    end

    def default
      Time.now
    end
  end
end