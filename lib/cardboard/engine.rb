module Cardboard
  class Engine < ::Rails::Engine
    isolate_namespace Cardboard
    # engine_name "cardboard"

    config.generators do |g|
      g.test_framework :mini_test,  :fixture => false #:spec => true,
    end

    # Force routes to be loaded if we are doing any eager load.
    # config.before_eager_load { |app| app.reload_routes! }

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
  end
end
