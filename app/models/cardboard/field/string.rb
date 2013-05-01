module Cardboard
  class Field::String < Field
    validates :value, :length => { :maximum => 255 }
    validates :value, presence:true, :if => :required_field?


    def default
      "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur"
    end
  end
end