module Cardboard
  class Engine < ::Rails::Engine
    isolate_namespace Cardboard

    config.generators do |g|
      g.test_framework :mini_test,  :fixture => false #:spec => true,
    end
  end
end
