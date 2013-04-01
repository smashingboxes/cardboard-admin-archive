module Cardboard
  class Document < ActiveRecord::Base
    serialize :fields_value, Hash
    attr_accessible :fields_value, :title, :url, :updated_at

    #associations
    belongs_to :collection

    #gems
    acts_as_url :title, only_when_blank: true

    #validations
    validates :title, :url, presence:true
    validates :url, uniqueness: { :case_sensitive => false }

    #overwritten getters

    #overwritten setters
    def url=(value)
      # the user can overwrite the generated url
      self[:url] = value.present? ? value.to_url : nil
    end

    #overwritten defaults
    def to_param
      url
    end

    #other methods
    def get(field)
      #get value for a field name (document attributes take precedence (example:title))
      out = self.fields_value[field.to_s]
      return out.blank? ? self[field.to_sym] : out
    end

  end
end
