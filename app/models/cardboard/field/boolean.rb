module Cardboard
  class Field::Boolean < Field
    validates :value, :inclusion => { :in => %w(yes true no false), :message => "%{value} is not a boolean" }, :allow_nil => true
    def value
      # super.to_bool
    end
  end
end