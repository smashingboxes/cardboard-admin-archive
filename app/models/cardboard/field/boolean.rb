module Cardboard
  class Field::Boolean < Field
    validates :value_uid, :inclusion => { :in => %w(yes true no false 0 1 y n), :message => "%{value} is not a boolean" }, :allow_nil => true
    # don't validate presence, nil == false

    def value
      super == "true"
    end

    def value=(v)
      self.value_uid = "true" if v == true || v =~ (/^(true|t|yes|y|1)$/i)
      self.value_uid = "false" if v == false || v.blank? || v =~ (/^(false|f|no|n|0)$/i)
    end


    def default
      [true, false].sample
    end
  end
end