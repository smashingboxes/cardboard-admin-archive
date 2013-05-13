module Cardboard
  class Field::Boolean < Field
    # validates :value, :inclusion => { :in => %w(yes true no false 0 1 y n t f) + [true, false], :message => "is not a boolean" }, :allow_nil => true
    # don't validate presence, nil == false
    validate :is_boolean?

    def value
      value_uid.to_s.to_boolean
    end

    def value=(val)
      self.value_uid = val
    end

    def default
      [true, false].sample
    end

    private

    def is_boolean?
      self.value rescue errors.add(:value, "is not a valid boolean")
    end
  end
end