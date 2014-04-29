require 'active_support/concern'

module Cardboard
  module UrlConcern
    extend ActiveSupport::Concern

    included do
      has_one :url_object, class_name: "Cardboard::Url", :as => :urlable, :autosave => true
   
      def url_object_with_auto_build
        build_url_object unless url_object_without_auto_build
        url_object_without_auto_build #to continue the association chain
      end
      alias_method_chain :url_object, :auto_build

      accepts_nested_attributes_for :url_object

      delegate :slug, :path, :slug=, :path=, :using_slug_backup?, to: :url_object, allow_nil: true
    end

    def url
      url_object.to_s
    end
  end
end