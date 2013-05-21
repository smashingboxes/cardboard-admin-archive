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


module Cardboard
  class Engine < ::Rails::Engine
    isolate_namespace Cardboard
    # engine_name "cardboard"

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
  end
end
