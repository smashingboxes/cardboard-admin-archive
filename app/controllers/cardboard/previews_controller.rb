require_dependency "cardboard/application_controller"

module Cardboard
  class PreviewsController < ApplicationController
    def create
      render text: view_context.markdown(params[:markdown])
    end
  end
end
