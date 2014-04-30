class PagesController < ApplicationController
  def show
    if current_page.nil?
      flash[:error] = "No root page! Make sure to add a page first"
      redirect_to cardboard.dashboard_path
    else
      if current_page.using_slug_backup?
        redirect_to current_page.url, status: :moved_permanently
      else
        # call controller hook
        @template_path = current_page.class.name.sub(/^Cardboard::/,'').underscore
        if @template_path == "page"
          self.send(current_page.identifier) if self.respond_to? current_page.identifier
          @template_path = current_page.template.identifier
        end

        render "cardboard/pages/show", layout: @layout || "layouts/application"
      end
    end
  end

private

  # def edit_link
  #   cardboard.edit_page_path(@page)
  # end
  # helper_method :edit_link

  def current_page
    return @page unless @page.nil?
    @page = if params[:id].blank?
      Cardboard::Page.root
    else
      Cardboard::Url.urlable_for(params[:id]) || raise(ActionController::RoutingError.new("Page not found"))
    end
  end

end
