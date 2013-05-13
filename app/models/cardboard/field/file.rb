module Cardboard
  class Field::File < Field
    attr_accessible :retained_value, :remove_value
    file_accessor :value

    validates_size_of :value, :maximum => 20.megabytes #20000.kilobytes #TODO: move size to gem settings
    validate :file_presence

  private
    def file_presence
      errors.add(:value, "is required") if required_field? && value_uid.blank? #for some reason this needs to be _uid (different from image)
    end
  end
end