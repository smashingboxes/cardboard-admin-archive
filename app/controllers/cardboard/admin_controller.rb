require_dependency "cardboard/application_controller"

module Cardboard
  class AdminController < ApplicationController
    before_filter :authenticate_user!

    def dashboard
      @page = Cardboard::Page.root
    end
  end
end
