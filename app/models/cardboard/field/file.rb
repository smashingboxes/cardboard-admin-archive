module Cardboard
  class Field::File < Field

    dragonfly_accessor :value

    validates_size_of :value, :maximum => 20.megabytes #20000.kilobytes #TODO: move size to gem settings
    validate :is_required #for some reason this is different from image

    def value
      return nil unless value_uid
      if value_uid =~ /^app\/assets\/files/
        Dragonfly.app.fetch_file(value_uid)
      else
        Dragonfly.app.fetch(value_uid)
      end
    end

  end
end