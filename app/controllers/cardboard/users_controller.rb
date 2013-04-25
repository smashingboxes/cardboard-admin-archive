require_dependency "cardboard/application_controller"

module Cardboard
  class UsersController < ApplicationController
    before_filter :authenticate_admin_user!
    def edit
      @user =  current_admin_user
    end

    def update
      @user =  current_admin_user
      if params[:admin_user][:password].blank?
        params[:admin_user].delete("password")
        params[:admin_user].delete("password_confirmation")
      end

      if @user.update_attributes(params[:admin_user])
        request.env['warden'].session_serializer.store(@user, :admin_user)
        flash[:success] = "User information updated successfully"
        redirect_to user_path
      else
        render :edit
      end
    end
  end
end
