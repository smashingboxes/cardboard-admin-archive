ApplicationController.class_eval do
  # helper Cardboard::Engine.helpers
  # helper Cardboard::PublicHelper

  def current_page
    nil #this will be overwritten only for cardboard pages
  end
  helper_method :current_page
end
