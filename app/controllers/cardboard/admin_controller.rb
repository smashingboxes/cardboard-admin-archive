module Cardboard
  class AdminController <  ActionController::Base#InheritedResources::Base
    #You can require all files in "#{RAILS_ROOT}/app/controllers" to populate your list in development mode.
    #Cardboard::AdminController.subclasses
    before_filter :authenticate_admin_user!
    layout "layouts/cardboard/application"

  end
end
