module Cardboard
  class Collection < ActiveRecord::Base
    attr_accessible :name, :url

    has_many :documents
    has_many :field_groups, :as => :editable_form
    has_many :fields, :through => :field_groups

    #validations
    validates :name, uniqueness: { :case_sensitive => false }
  end
end
