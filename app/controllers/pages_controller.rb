class PagesController < ApplicationController
  def show

    raise ActionController::RoutingError.new("Page Not Found") if current_page.nil?

    if current_page.using_slug_backup?
      redirect_to current_page.url, status: :moved_permanently
    else
      # call controller hook
      self.send(current_page.identifier) if self.respond_to? current_page.identifier
      render_main_app_page current_page
    end
  end

private

  # def edit_link
  #   cardboard.edit_page_path(@page)
  # end
  # helper_method :edit_link

  def current_page
    @page ||= Cardboard::Page.find_by_url(params[:id]) || Cardboard::Page.root
  end
  helper_method :current_page


  def render_main_app_page(page)
    #TODO: Make the layout name variable
    render "pages/#{page.identifier}", layout: @layout || "layouts/application"

  rescue ActionView::MissingTemplate => e
    @missing_file = e.path
    render "cardboard/pages/error"#, layout: "layouts/application"
  end
end
