require_dependency "cardboard/application_controller"

module Cardboard
  class TemplatesController < ApplicationController
    before_filter :only_development

    def new
      @template = Cardboard::Template.new
    end

    def edit
      @template = Cardboard::Template.find(params[:id])
    end

    def update
      @template = Cardboard::Template.find(params[:id])
      if save
        flash[:notice] = "Template updated successfully"
        redirect_to new_page_path
      else
        render :edit
      end
    end

    def create
      @template = Cardboard::Template.new
      if save
        flash[:notice] = "Template created successfully"
        redirect_to new_page_path
      else
        render :new
      end
    end

    def destroy
      @template = Cardboard::Template.find(params[:id])
      @template.destroy
    end

    private

    def save
      binding.pry
      p = params.require(:template)
      @template.name = p[:name]
      @template.thumbnail = p[:thumbnail]
      @template.fields = p[:parts]
      @template.save
    end

    def only_development
      redirect_to dashboard_path unless Rails.env.development?
    end
  end
end
