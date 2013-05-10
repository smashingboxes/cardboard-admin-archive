module Cardboard
  class Field::File < Field
    attr_accessible :retained_value, :remove_value
    file_accessor :value

    validates_size_of :value, :maximum => 20.megabytes #20000.kilobytes #TODO: move size to gem settings
    validates :value, presence:true, :if => :required_field?

    after_validation :remove_uid_on_error

  private
    def remove_uid_on_error
      self.value_uid = nil unless self.errors.empty?
    end
  end
end