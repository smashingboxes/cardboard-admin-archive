require_dependency "cardboard/application_controller"

module Cardboard
  class PagesController < ApplicationController
    before_filter :check_ability

    def edit
      @page = Cardboard::Page.find(params[:id])
    end

    def update
      @page = Cardboard::Page.find(params[:id])
      fix_new_subparts

      if @page.update_attributes(strong_params[:page])
        flash[:success] = "Your page was updated successfully"
        redirect_to edit_page_path(@page)
      else
        render :edit
      end
    end

    def sort
      params[:pages].each_with_index do |id, index|
        Page.find(id).update_attribute(:position_position, index + 1)
      end
      render nothing: true
    end

  private
    def check_ability
      unless cardboard_user_can_manage?(:pages)
        render :text => "You are not authorized to edit pages.", :status => :unauthorized 
      end
    end

    def fix_new_subparts
      #subparts need to be build based on the parent part to have the correct fields
      return nil if params[:page].blank? || params[:page][:parts_attributes].blank?

      params[:page][:parts_attributes].each do |k, p| 
        parent_part_id = p["id"]
        parent = @page.parts.find(parent_part_id)

        p["subparts_attributes"].each do |k,sub| 
          next unless sub["id"].blank? #if already assigned to a database record
          if sub[:fields_attributes].inject(true){|v,(i, h)| v && h[:value].blank?} 
            p["subparts_attributes"].delete(k) #reject if all values are blank (subpart is empty)
            next
          end
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
