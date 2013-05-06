module Cardboard
  class Field::File < Field
    attr_accessible :retained_value, :remove_value
    file_accessor :value

    validates_size_of :value, :maximum => 20.megabytes #20000.kilobytes #TODO: move size to gem settings
    validates_presence_of :value_uid, :if => :required_field?
    # validates_property :image?, :of => :value, :in => [false]

  end
end