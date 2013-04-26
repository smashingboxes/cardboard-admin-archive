module Cardboard
  class ApplicationController < ActionController::Base

    before_filter :for_gon
    protect_from_forgery
    
    private

    def for_gon
      gon.rich_text_links_modal = render_to_string(:partial => "cardboard/rich_editor/links_modal", :layout => false)
    end

  end
end
