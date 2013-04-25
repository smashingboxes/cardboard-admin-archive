require_dependency Cardboard::Engine.root.join('app', 'controllers', 'cardboard', 'admin_controller')
module Cardboard
  class Test < AdminController
    inherit_resources
    def index
    end
  end
end