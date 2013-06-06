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
require 'ransack'
require 'kaminari'
require 'rack-pjax'
# require 'decorators'


module Cardboard
  class Engine < ::Rails::Engine
    isolate_namespace Cardboard

    # class << self
    #   attr_accessor :root
    #   def root
    #     @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
    #   end
    # end

    config.generators do |g|
      g.test_framework :mini_test,  :fixture => false, :spec => true
    end

    # Let the main app use the cardboard helpers
    initializer "public cardboard helpers" do |app|
      ActiveSupport.on_load(:action_controller) do
        #helper Cardboard::Engine.helpers
        helper Cardboard::PublicHelper
      end
    end

    initializer "set resource controller for generator" do |app|
      Cardboard.set_resource_controllers
    end

    # the to_prepare gets executed even before autoreloads
    config.to_prepare do
      #Decorators.register! Engine.root, Rails.root
      #TODO: figure out why the decorator doesn't auto reload

      # Load custom resource controllers in development (already loaded in production)
      Cardboard.set_resource_controllers
      # if Rails.env.development?
      #   Dir[Rails.root.join('app/controllers/cardboard/*_controller.rb')].map.each do |controller|
      #     require_dependency controller
      #   end
      # end
      # Cardboard.resource_controllers = Cardboard::AdminController.descendants
    end

    if Rails.version > "3.1"
      initializer "precompile hook", :group => :all do |app|
        app.config.assets.precompile += %w(cardboard.js cardboard.css)
      end
    end

    initializer "pjax hook" do |app|
      app.config.middleware.use Rack::Pjax
    end

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'../tasks/*.rake')].each { |f| load f }
    end

    config.after_initialize do
      # Add load paths straight to I18n, so engines and application can overwrite it.
      require 'active_support/i18n'
      I18n.load_path.unshift *Dir[File.expand_path('../cardboard/locales/*.yml', __FILE__)]
    end    
  end
end
