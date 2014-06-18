ApplicationController.class_eval do
  # helper Cardboard::Engine.helpers
  # helper Cardboard::PublicHelper

  def current_page
    #nil default for non cardboard pages
    #overwritten otherwise by url controller
    nil 
  end
  helper_method :current_page
end
