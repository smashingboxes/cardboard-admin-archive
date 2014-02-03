module Cardboard
  class Field < ActiveRecord::Base
    attr_accessor :seeding, :default
    alias_attribute :value, :value_uid

    belongs_to :object_with_field, :polymorphic => true, :inverse_of => :fields

    #gem
    include RankedModel
    ranks :position, :with_same => [:object_with_field_id, :object_with_field_type], :class_name => 'Cardboard::Field'

    #validations
    validates :identifier, :type, presence:true
    validates :identifier, uniqueness: {:case_sensitive => false, :scope => [:object_with_field_id, :object_with_field_type]}, 
                          :format => { :with => /\A[a-z\_0-9]+\z/,
                          :message => "Only lowercase letters, numbers and underscores are allowed" }

    default_scope {rank(:position)}

    class << self
      # Allow "type" to be passed in nested forms
      def new_with_castnew(*attributes, &block)
        if (h = attributes.first).is_a?(Hash) && !h.nil? && (type = h.delete(:type) || h.delete('type')) && type.present? && (klass = type.constantize) != self
          raise "Field type #{type} does not inherit from Cardboard::Field"  unless klass <= self
          return klass.new(*attributes, &block)
        end
        new_without_castnew(*attributes, &block)
      end
      alias_method_chain :new, :castnew

      # def build_with_castbuild(*attributes, &block)
      #   if (h = attributes.first).is_a?(Hash) && !h.nil? && (type = h.delete(:type) || h.delete('type')) && type.present? && (klass = type.constantize) != self
      #     raise "Field type #{type} does not inherit from Cardboard::Field"  unless klass <= self
      #     return klass.build(*attributes, &block)
      #   end
      #   new_without_castbuild(*attributes, &block)
      # end
      # alias_method_chain :build, :castbuild
    end

    # overwritten setter
    def type=(val)
      return super if val =~ /^Cardboard::Field::/ || val.nil?
      @_type = val.to_s.downcase
      self[:type] = "Cardboard::Field::#{@_type.camelize}"
    end
    def type
      @_type ||= self[:type].demodulize.underscore
    end

    def default
      #overwritten for each subclass
    end
    def default=(val) 
      return unless self.value_uid.nil? && val.present?
      if type == "image" || type == "file"
        path = "app/assets/#{type.pluralize}/defaults/#{val}"
        raise "File not found #{path}. Make sure to add your #{type} before seeding." unless ::File.exist?(Rails.root.join(path))
        self.value_uid = path
      else
        self.value_uid = val 
      end
    end

  private

    def is_required
      errors.add(:value, "is required") if required_field? && value_uid.blank?
    end
    
    def required_field?
      required = self.object_with_field.template[self.identifier][:required]
      required = true if required.nil?
 
      required && !self.seeding
    end

  end
end
