require_dependency "cardboard/application_controller"

module Cardboard
  class SuperUserController < ApplicationController
    before_filter :authenticate_admin_user!

    def index
    end
  end
end
