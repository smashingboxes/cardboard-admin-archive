require "cardboard/engine"

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


