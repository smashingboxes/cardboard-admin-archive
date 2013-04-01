module Cardboard
  class Page < ActiveRecord::Base
    attr_accessible :position, :title, :url
    has_many :field_groups, :as => :editable_form
    has_many :fields, :through => :field_groups
  end
end
