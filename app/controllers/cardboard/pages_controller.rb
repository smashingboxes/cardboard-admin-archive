require_dependency "cardboard/application_controller"

module Cardboard
  class PagesController < ApplicationController
    before_filter :authenticate_admin_user!, except: [:show, :index]

    def show
      # for nav
      # @pages = Cardboard::Page.all

      # rest of page
      @page = Cardboard::Page.find_by_url(params[:id])
      render layout: "layouts/application" #TODO: Make the layout name variable
    end

    def index
      @page = Cardboard::Page.root
      render :show, layout: "layouts/application"
    end

    def edit
      @page = Cardboard::Page.find(params[:id])
    end

    def update
      @page = Cardboard::Page.find(params[:id])

      if @page.update_attributes(params[:cardboard_page])
        flash[:success] = "Your page at \"#{@page.url}\" was updated"
        redirect_to cardboard_dashboard_path
      else
        render :edit
      end
    end

    def destroy
    end

  end
end
