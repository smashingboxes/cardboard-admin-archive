module Cardboard
  class Field::String < Field
    validates :value, :length => { :in => 2..255 }, :allow_nil => true

    def default
      "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur"
    end
  end
end