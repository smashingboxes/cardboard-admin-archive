require 'rails'
require 'cardboard_cms'

module Cardboard
  module Generators
    class AssetsGenerator < Rails::Generators::Base

      def self.source_root
        @_cardboard_source_root ||= Cardboard::Engine.root.join('app', 'assets')#File.expand_path("../templates", __FILE__)
      end

      def install_assets
        template 'javascripts/cardboard.js', 'app/assets/javascripts/cardboard.js'
        template 'stylesheets/cardboard.css.scss', 'app/assets/stylesheets/cardboard.css.scss'
      end
    end
  end
end
