require_dependency "cardboard/application_controller"

module Cardboard
  class PagesController < ApplicationController
    before_filter :authenticate_admin_user!, except: [:show, :index]

    def show
      @page = Cardboard::Page.find_by_url(params[:id])
      render_main_app_page @page
    end

    def index
      @page = Cardboard::Page.root
      render_main_app_page @page
    end

    def edit
      @page = Cardboard::Page.find(params[:id])
    end

    def update
      @page = Cardboard::Page.find(params[:id])
      fix_new_subparts

      if @page.update_attributes(params[:page])
        flash[:success] = "Your page was updated successfully"
        redirect_to edit_page_path(@page)
      else
        render :edit
      end
    end


  private

    def current_page
      @page
    end
    helper_method :current_page

    def render_main_app_page(page)
      #TODO: Make the layout name variable
      render "pages/#{page.identifier}", layout: "layouts/application"
    rescue ActionView::MissingTemplate => e
      @missing_file = e.path
      render "error", layout: "layouts/application"
    end

    def fix_new_subparts
      return nil if params[:page].blank?

      params[:page][:parts_attributes].each do |k, p| 
        parent_part_id = p["id"]
        parent = @page.parts.find(parent_part_id)

        p["subparts_attributes"].each do |k,sub| 
          next unless sub["id"].blank?
          
          subpart = parent.new_subpart
          subpart.save! #TODO: find a way to initialize instead of save while avoiding mass assignment issues
          sub.reverse_merge!({"id" => "#{subpart.id}"})
          subpart.fields.each_with_index do |field, i|
            sub["fields_attributes"][i.to_s].reverse_merge!({"id" => "#{field.id}"}) if sub["fields_attributes"][i.to_s]
          end
        end
      end
    end

  end
end
