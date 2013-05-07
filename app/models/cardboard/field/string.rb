module Cardboard
  class Field::String < Field
    # validates :value, :length => { :maximum => 255 }
    validates :value, presence:true, :if => :required_field?
    before_validation :truncate_long_string

    def default
      "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur"
    end

    private

    def truncate_long_string
      self.value = self.value[1..255] if value
    end
  end
end