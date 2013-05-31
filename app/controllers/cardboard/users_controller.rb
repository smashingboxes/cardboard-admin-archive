require_dependency "cardboard/application_controller"

module Cardboard
  class UsersController < ApplicationController

    def edit
      @user =  cardboard_user
    end

    def update
      admin_user_method = Cardboard.user_class.to_s.underscore.gsub(/\//,'_').to_sym
      @user =  cardboard_user
      if params[admin_user_method][:password].blank?
        params[admin_user_method].delete("password")
        params[admin_user_method].delete("password_confirmation")
      end

      if @user.update_attributes(strong_params[admin_user_method])
        request.env['warden'].session_serializer.store(@user, admin_user_method)
        flash[:success] = "User information updated successfully"
        redirect_to user_path
      else
        render :edit
      end
    end
  end
end
