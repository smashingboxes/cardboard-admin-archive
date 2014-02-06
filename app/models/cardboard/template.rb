module Cardboard
  class Template < ActiveRecord::Base

    serialize :fields, Hash

    has_many :pages

    validates :identifier, uniqueness: {:case_sensitive => false}, :format => { :with => /\A[a-z\_0-9]+\z/,
                           :message => "Only downcase letters, numbers and underscores are allowed" }


    def thumbnail
      return nil unless self[:thumbnail] =~ /^app\/assets\/images/
      Dragonfly.app.fetch_file(self[:thumbnail])
    end

  end
end
