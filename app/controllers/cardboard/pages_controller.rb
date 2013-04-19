require_dependency "cardboard/application_controller"

module Cardboard
  class PagesController < ApplicationController
    before_filter :authenticate_admin_user!, except: [:show, :index]

    def show
      # for nav
      # @pages = Cardboard::Page.all

      # rest of page
      @page = Cardboard::Page.find_by_url(params[:id])
      render layout: "layouts/application" #TODO: Make the layout name variable
    end

    def index
      @page = Cardboard::Page.root
      render :show, layout: "layouts/application"
    end

    def edit
      @page = Cardboard::Page.find(params[:id])
    end

    def update
      @page = Cardboard::Page.find(params[:id])
      fix_new_subparts

      if @page.update_attributes(params[:cardboard_page])
        flash[:success] = "Your page was updated successfully"

        redirect_to edit_cardboard_page_path(@page)
      else
        render :edit
      end
    end

    def destroy
    end

  private

    def fix_new_subparts
      params[:cardboard_page][:parts_attributes].each do |k, p| 
        parent_part_id = p["id"]
        parent = @page.parts.find(parent_part_id)

        p["subparts_attributes"].each do |k,sub| 
          next unless sub["id"].blank?
          
          subpart = parent.new_subpart
          subpart.save! #TODO: find a way to initialize instead of save while avoiding mass assignment issues
          sub.reverse_merge!({"id" => "#{subpart.id}"})
          subpart.fields.each_with_index do |field, i|
            sub["fields_attributes"]["#{i}"].reverse_merge!({"id" => "#{field.id}"})
          end
        end
      end
    end

  end
end
