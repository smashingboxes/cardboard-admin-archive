module Cardboard
  class Field::Boolean < Field
    validates :value_uid, :inclusion => { :in => %w(yes true no false 0 1 y n), :message => "%{value} is not a boolean" }, :allow_nil => true
    # don't validate presence, nil == false

    def value
      super == "true"
    end

    def value=(val)
      self[:value_uid] = val.to_boolean.to_s
    end

    def default
      [true, false].sample
    end
  end
end