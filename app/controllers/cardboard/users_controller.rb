require_dependency "cardboard/application_controller"

module Cardboard
  class UsersController < ApplicationController
    def edit
      @user = User.where(id: params[:id]).first || current_user
    end
  end
end
