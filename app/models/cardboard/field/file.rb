module Cardboard
  class Field::File < Field
    dragonfly_accessor :value

    validates_size_of :value, maximum: 20.megabytes #TODO: move size to gem settings
    validate :is_required

    def value
      return nil unless value_uid
      if value_uid =~ value_uid_regex
        Dragonfly.app.fetch_file value_uid
      else
        Dragonfly.app.fetch value_uid
      end
    end

    protected

    def value_uid_regex
      /^app\/assets\/files/
    end
  end
end
