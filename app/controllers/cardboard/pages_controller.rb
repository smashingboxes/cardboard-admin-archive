require_dependency "cardboard/application_controller"

module Cardboard
  class PagesController < ApplicationController
    before_filter :check_ability

    def edit
      @page = Cardboard::Page.find(params[:id])
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
