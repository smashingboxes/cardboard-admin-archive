require_dependency "cardboard/application_controller"
require_dependency Cardboard::Engine.root.join('lib/cardboard/helpers/seed.rb').to_s

module Cardboard
  class PagesController < ApplicationController
    before_filter :check_ability

    def new
      @page = Cardboard::Page.new
    end

    def edit
      @page = Cardboard::Page.find(params[:id])
    end

    def create
      @page = Cardboard::Page.new(params.require(:page).permit(:title, :identifier, :template_id))
      @page.identifier = @page.title.to_url.underscore if @page.identifier.blank?
      @page.save
      Cardboard::Seed.populate_page(@page, @page.template.fields)
      redirect_to edit_page_path(@page)
    end

    def update
      @page = Cardboard::Page.find(params[:id])

      if @page.update_attributes(strong_params[:page])
        flash[:success] = "Your page was updated successfully"
        redirect_to edit_page_path(@page)
      else
        render :edit
      end
    end

    def sort
      Page.find(params[:id]).update_attribute(:position_position, params[:index])
      render nothing: true
    end

  private
    def check_ability
      unless cardboard_user_can_manage?(:pages)
        render :text => "You are not authorized to edit pages.", :status => :unauthorized 
      end
    end
  end
end
