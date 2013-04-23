module Cardboard
  class Field::String < Field
    validates :value, :length => { :in => 1..255 }, :allow_nil => true
    validates :value, presence:true, :if => :required_field?


    def default
      "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur"
    end
  end
end