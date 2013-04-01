module Cardboard
  class Field::Boolean < Field
    validates :value, :inclusion => { :in => %w(yes true no false), :message => "%{value} is not a boolean" }
    def value
      # self[:value].to_bool
    end
  end
end