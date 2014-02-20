module Cardboard
  class Setting < ActiveRecord::Base
    # self.table_name = "cardboard_settings"
    # attr_accessible :name, :fields_attributes

    has_many :fields, :as => :object_with_field
    accepts_nested_attributes_for :fields, :allow_destroy => true

    serialize :template, Hash


    # thread save caching of the settings
    @lock = ::Mutex.new
    after_commit do
      Setting.clear_saved_settings
      Rails.cache.write("Cardboard::Setting", true)
    end

    class << self
      def add(id, hash_attributes)
        myself = self.first_or_create
        field = myself.fields.where(identifier: id).first_or_initialize
        field.update_attributes!(hash_attributes)
      end

      def clear_saved_settings
        @lock.synchronize do
          @_settings = nil
        end
      end

      def method_missing(sym, *args, &block)
        begin
          super
        rescue
          @lock.synchronize do
            @_settings ||= {}
            @_settings[sym.to_sym] ||= begin
              return nil unless self.first
              s = self.first.fields.where(identifier: sym.to_s).first
              raise ::ActiveRecord::NoMethodError if s.nil?
              s.value
            end
          end
        end
      end
    end

  end
end
