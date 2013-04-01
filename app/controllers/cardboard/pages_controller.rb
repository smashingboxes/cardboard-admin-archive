require_dependency "cardboard/application_controller"

module Cardboard
  class PagesController < ApplicationController
    def show
      @pages = Page.all
      url = params[:id].split("/")
      if url.size == 1
        @page = Page.find_by(url: params[:id])
      elsif url.size == 2
        @page = Collection.find_by!(url: url[0]).documents.find_by(url: url[1])
      end
    end
  end
end
