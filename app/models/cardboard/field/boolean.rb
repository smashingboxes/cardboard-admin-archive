module Cardboard
  class Field::Boolean < Field
    validates :value, :inclusion => { :in => %w(yes true no false), :message => "%{value} is not a boolean" }, :allow_nil => true
    def value
      v = super
      return true if v == true || v =~ (/^(true|t|yes|y|1)$/i)
      return false if v == false || v.blank? || v =~ (/^(false|f|no|n|0)$/i)
    end

    def default
      [true, false].sample
    end
  end
end