# require_dependency "application_controller"
class Cardboard::AdminController <  ActionController::Base

  #Cardboard::AdminController.subclasses
  before_filter :authenticate_admin_user!
  layout "layouts/cardboard/application"

end

