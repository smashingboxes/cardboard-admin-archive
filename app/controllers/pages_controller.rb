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
      self.send(current_page.identifier) if self.respond_to? current_page.identifier

      render "cardboard/pages/show", layout: @layout || "layouts/application"
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
end
