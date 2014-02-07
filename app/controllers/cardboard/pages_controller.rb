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
      @page = Cardboard::Page.new(params.require(:page).permit(:title, :template_id))
      @page.identifier = @page.title.to_url.underscore if @page.identifier.blank?
      if @page.save
        Cardboard::Seed.populate_parts(@page.template.fields, @page)
        @page.reload
        redirect_to edit_page_path(@page)
      else
        @page.errors.add(:title, "is reserved or is already used") if @page.errors[:identifier].present?
        render :new
      end
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
      Cardboard::Page.find(params[:id]).update_attribute(:position_position, params[:index])
      render nothing: true
    end

    def destroy
      @page = Cardboard::Page.find(params[:id])
      @page.destroy
      redirect_to pages_path
    end

  private
    def check_ability
      unless cardboard_user_can_manage?(:pages)
        render :text => "You are not authorized to edit pages.", :status => :unauthorized 
      end
    end
  end
end
