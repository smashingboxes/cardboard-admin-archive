module Cardboard
  class Field::Date < Field
    validate :is_required
    validate :is_date

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
      errors.add(:value, "not a recognized date format") if value_uid.present? && value.blank?
    end
  end
end