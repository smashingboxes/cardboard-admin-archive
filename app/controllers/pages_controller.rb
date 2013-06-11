class PagesController < ApplicationController
  def show
    if params[:id].present?
      @page = Cardboard::Page.find_by_url(params[:id])
    else
      @page = Cardboard::Page.root
    end

    raise ActionController::RoutingError.new("Page Not Found") if @page.nil?

    if @page.using_slug_backup?
      redirect_to @page.url, status: :moved_permanently
    else
      # call controller hook
      self.send(@page.identifier) if self.respond_to? @page.identifier
      render_main_app_page @page
    end
  end

private

  # def edit_link
  #   cardboard.edit_page_path(@page)
  # end
  # helper_method :edit_link

  def current_page
    @page
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
