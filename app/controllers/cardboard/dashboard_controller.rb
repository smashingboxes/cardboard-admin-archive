require_dependency "cardboard/application_controller"

module Cardboard
  class DashboardController < ApplicationController
    def index
      @page = Cardboard::Page.root
    end
  end
end
