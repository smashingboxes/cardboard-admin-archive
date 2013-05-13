module Cardboard
  class Field::Date < Field
    validates :value, presence:true, :if => :required_field?
    validate :is_date, :if => :required_field?

    def value
      Chronic.parse(value_uid)
    end

    def value=(val)
      self.value_uid = val
    end

    def default
      Time.now
    end

    private

    def is_date
      errors.add(:value, "not a recognized date format") unless value
    end
  end
end