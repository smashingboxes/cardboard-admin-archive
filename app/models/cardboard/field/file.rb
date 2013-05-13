module Cardboard
  class Field::File < Field
    attr_accessible :retained_value, :remove_value
    file_accessor :value

    validates_size_of :value, :maximum => 20.megabytes #20000.kilobytes #TODO: move size to gem settings
    validate :is_required #for some reason this is different from image
  end
end