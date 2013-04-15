require_dependency "cardboard/application_controller"

module Cardboard
  class UsersController < ApplicationController
    def edit
      @user = AdminUser.where(id: params[:id]).first || current_admin_user
    end
  end
end
