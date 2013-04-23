module Cardboard
  class Field::File < Field
    attr_accessible :retained_value, :remove_value
    file_accessor :value

    validates_size_of :value, :maximum => 20.megabytes #20000.kilobytes
    validates_presence_of :value_uid, :if => :required_field?
    validates_property :image?, :of => :value, :as => true
    validate :test

    def test
      binding.pry
    end
  end
end