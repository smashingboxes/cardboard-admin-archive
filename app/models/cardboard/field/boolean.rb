module Cardboard
  class Field::Boolean < Field
    validates :value_uid, :inclusion => { :in => %w(yes true no false 0 1 y n t f), :message => "%{value} is not a boolean" }, :allow_nil => true
    # don't validate presence, nil == false

    def value
      super.to_s.to_boolean
    end

    # def value=(val)
    #   self[:value_uid] = val
    # end

    def default
      [true, false].sample
    end
  end
end