require "cardboard/engine"
require 'rubygems'
require 'simple_form'
require 'stringex'
require 'ranked-model'
require 'devise'
require 'cocoon'


module Cardboard
  autoload :Application,              'cardboard/application'
  autoload :Devise,                   'cardboard/devise'

  class Railtie < ::Rails::Railtie
    config.after_initialize do
      # Add load paths straight to I18n, so engines and application can overwrite it.
      require 'active_support/i18n'
      I18n.load_path.unshift *Dir[File.expand_path('../cardboard/locales/*.yml', __FILE__)]
    end
  end

  class << self

    attr_accessor :application

    def application
      @application ||= ::Cardboard::Application.new
    end

    # Gets called within the initializer
    def setup
      # application.setup!
      yield(application)
      # application.prepare!
    end

    # delegate :register,      :to => :application
    # delegate :register_page, :to => :application
    # delegate :unload!,       :to => :application
    # delegate :load!,         :to => :application
    # delegate :routes,        :to => :application

 
  end

end

# Cardboard::DependencyChecker.check!

