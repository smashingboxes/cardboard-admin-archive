module Cardboard
  module Generators
    class AssetsGenerator < Rails::Generators::Base

      def self.source_root
        @_cardboard_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def install_assets
        require 'rails'
        require 'cardboard'

        template 'cardboard.js', 'app/assets/javascripts/cardboard.js'
        template 'cardboard.css.scss', 'app/assets/stylesheets/cardboard.css.scss'
      end
    end
  end
end
