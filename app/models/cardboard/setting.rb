module Cardboard
  class Setting < ActiveRecord::Base
    # self.table_name = "cardboard_settings"
    attr_accessible :name, :fields_attributes

    has_many :fields, :as => :object_with_field
    accepts_nested_attributes_for :fields, :allow_destroy => true

    # thread save caching of the settings
    @lock = ::Mutex.new
    after_commit do
      Setting.clear_saved_settings
    end

    class << self
      def add(id, hash_attributes)
        field = self.first.fields.where(identifier: id).first_or_initialize
        field.update_attributes!(hash_attributes, :without_protection => true)
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
              s = self.first.fields.where(identifier: sym).first
              raise ::ActiveRecord::NoMethodError if s.nil?
              s.value
            end
          end
        end
      end
    end

  end
end
