ApplicationController.class_eval do
  # helper Cardboard::Engine.helpers
  # helper Cardboard::PublicHelper

  def current_page
    nil #this will be overwritten only for cardboard pages
  end
  helper_method :current_page

  # Example: 
  #  page_path(:home)
  #   
  def page_path(identifier)
    Cardboard::Page.where(identifier: identifier.to_s).first.try(:url)
  end
  helper_method :page_path
end
