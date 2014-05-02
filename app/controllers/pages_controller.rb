class PagesController < ApplicationController

  def router
    if current_page.using_slug_backup?
      redirect_to current_page.url, status: :moved_permanently
    else
      # call controller hook
      @template_path = "page"
      self.send(current_page.identifier) if self.respond_to? current_page.identifier
      @template_path = current_page.template.identifier
    
      render "cardboard/pages/show", layout: @layout || "layouts/application"
    end
  end

private

  def current_page
    return @cardboard_page unless @cardboard_page.nil?
    @cardboard_page = if params[:id].blank?
      Cardboard::Page.root
    else
      Cardboard::Url.urlable_for(params[:id]) || raise(ActionController::RoutingError.new("Page not found"))
    end
  end
end
