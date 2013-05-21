module Cardboard
  class ApplicationController < ActionController::Base

    before_filter do #:authenticate_admin_user!
      self.send(Cardboard.application.authentication_method)
    end
    before_filter :for_gon
    protect_from_forgery
    
  private

    def cardboard_user
      @cardboard_user ||= self.send(Cardboard.application.current_admin_user_method)
    end
    helper_method :cardboard_user

    def for_gon
      gon.rich_text_links_modal = render_to_string(:partial => "cardboard/rich_editor/links_modal", :layout => false)
    end

    def strong_params
      return params if request.get? || params.blank? || params.class.to_s != "ActionController::Parameters"
      # #remove once conversion to strong params is complete
      params.permit!
    end

  end
end
