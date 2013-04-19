module Cardboard
  class Setting < ActiveRecord::Base
    self.table_name = "cardboard_settings"
    attr_accessible :default_value, :description, :format, :name, :value

    def value
      self[:value] = self.default_value unless self[:value].present?
      formatted(self[:value])
    end

    private

    def self.method_missing(sym, *args, &block)
      begin
        super
      rescue
        field = self.where(name: sym).first
      end
      raise ActiveRecord::NoMethodError if field.nil?
      field.value
    end

    def formatted(val)
      out = case self.format.to_sym
      when :string
        val.to_s
      when :integer
        val.to_i
      when :boolean
        val.to_bool
      else
        val
      end 
      return out
    end
  end
end
