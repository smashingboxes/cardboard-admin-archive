module Cardboard
  class ApplicationController < ActionController::Base

    before_filter do #:authenticate_admin_user!
      self.send(Cardboard.application.authentication_method)
    end
    before_filter :for_gon
    protect_from_forgery
    
  private

    def cardboard_user_can_manage?(resource)
      if cardboard_user.respond_to?(:can_manage_cardboard?)
        cardboard_user.can_manage_cardboard?(resource.to_sym)
      else
        true
      end
    end
    helper_method :cardboard_user_can_manage?

    # def active_resource_controller?
    #   for c in Cardboard.resource_controllers
    #     return true if current_admin_user.can_manage_cardboard?(c.controller_name.to_sym)
    #   end
    #   false
    # end
    # helper_method :active_resource_controller?

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
