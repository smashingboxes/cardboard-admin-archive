require_dependency "cardboard/application_controller"

module Cardboard
  class SettingsController < ApplicationController
    # before_filter :authenticate_admin_user!

    def index
      @setting = Setting.first
    end

    def update
      @setting = params[:id].present? ? Setting.find(params[:id]) : Setting.first
      if @setting.update_attributes(params[:setting])
        flash[:success] = "Settings updated successfully"
        redirect_to settings_path
      else
        render :index
      end

    end
  end
end
