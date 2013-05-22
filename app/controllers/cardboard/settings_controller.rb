require_dependency "cardboard/application_controller"

module Cardboard
  class SettingsController < ApplicationController
    before_filter :check_ability

    def index
      @setting = Setting.first
    end

    def update
      @setting = params[:id].present? ? Setting.find(params[:id]) : Setting.first
      if @setting.update_attributes(strong_params[:setting])
        flash[:success] = "Settings updated successfully"
        redirect_to settings_path
      else
        render :index
      end
    end

  private
    def check_ability
      unless cardboard_user_can_manage?(:settings)
        render :text => "You are not authorized to edit settings.", :status => :unauthorized 
      end
    end
  end
end
