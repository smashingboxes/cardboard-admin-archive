require_dependency "cardboard/application_controller"

module Cardboard
  class DashboardController < ApplicationController
    before_filter :authenticate_admin_user!

    def index
      @page = Cardboard::Page.root
    end
  end
end
