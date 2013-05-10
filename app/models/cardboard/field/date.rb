module Cardboard
  class Field::Date < Field
    validates :value, presence:true, :if => :required_field?
    validate :is_date

    def value
      Chronic.parse(super)
    end

    def default
      Time.now
    end

    private

    def is_date
      errors.add(:value, "not a recognized date format") unless Chronic.parse(value_uid)
    end
  end
end