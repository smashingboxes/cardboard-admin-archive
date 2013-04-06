module Cardboard
  class Engine < ::Rails::Engine
    isolate_namespace Cardboard

    config.generators do |g|
      g.test_framework :mini_test,  :fixture => false #:spec => true,
    end

    # Force routes to be loaded if we are doing any eager load.
    config.before_eager_load { |app| app.reload_routes! }

    # Let the main app use the cardboard helpers
    initializer "cardboard.helpers" do
      ActiveSupport.on_load(:action_controller) do
        # helper Cardboard::Engine.helpers
        helper Cardboard::ApplicationHelper
      end
    end

  end
end
