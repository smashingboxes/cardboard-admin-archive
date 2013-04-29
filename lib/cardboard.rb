require "cardboard/engine"
require 'rubygems'
require 'simple_form'
require 'stringex'
require 'ranked-model'
require 'devise'
require 'cocoon'
require 'inherited_resources'
require 'gon'
require 'rack/cache'
require 'dragonfly'
require 'chronic'
require 'font-awesome-sass-rails'
require 'bootstrap-sass'
require 'bootstrap-wysihtml5-rails'
require 'bootstrap-datepicker-rails'
require 'slim'
require 'haml' #remove please! (when all templates are converted)
require 'strong_parameters'



module Cardboard
  autoload :Application,              'cardboard/application'
  autoload :Devise,                   'cardboard/devise'

  class Railtie < ::Rails::Railtie
    config.after_initialize do
      # Add load paths straight to I18n, so engines and application can overwrite it.
      require 'active_support/i18n'
      I18n.load_path.unshift *Dir[File.expand_path('../cardboard/locales/*.yml', __FILE__)]

      if Rails.env.development?
        Dir[Rails.root.join('app/controllers/cardboard/*_controller.rb')].map.each do |controller|
          require_dependency controller
        end
      end
    end
  end

  class << self

    attr_accessor :application

    def application
      @application ||= ::Cardboard::Application.new
    end

    # Gets called within the initializer
    def setup

      yield(application)

    end
  end

end


