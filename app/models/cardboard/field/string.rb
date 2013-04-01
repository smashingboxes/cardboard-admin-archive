module Cardboard
  class Field::String < Field
    validates :value, :length => { :in => 2..255 }
  end
end