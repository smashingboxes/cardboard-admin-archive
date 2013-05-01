module Cardboard
  class ApplicationController < ActionController::Base
    before_filter :authenticate_admin_user!
    before_filter :for_gon, :bypass_strong_params
    protect_from_forgery
    
    private

    def for_gon
      gon.rich_text_links_modal = render_to_string(:partial => "cardboard/rich_editor/links_modal", :layout => false)
    end

    def bypass_strong_params
      return if request.get? || params.blank? || params.class.to_s != "ActionController::Parameters"
      # #remove once conversion to strong params is complete
      params.permit!
    end

  end
end
