require 'active_support/concern'

module Cardboard

  module Seed
    extend ActiveSupport::Concern

    def self.populate_templates(templates)
      templates ||= {}
      templates.each do |id, template|
        db_template = Cardboard::Template.where(identifier: id.to_s).first_or_initialize
        
        db_template.update_attributes!(name: template[:title] || template[:name], fields: template[:parts]) 
      end

      for remove_template in Cardboard::Template.all.map(&:identifier) - templates.map{|k,v|k.to_s}
        Cardboard::Template.where(identifier: remove_template).first.destroy
      end
    end

    def self.populate_pages(pages)
      pages ||= {}

      # create the template
      populate_templates(pages)

      # add the page
      pages.each do |id, page|
        db_page = Cardboard::Page.where(identifier: id.to_s).first_or_initialize
        db_page.position_position = page[:position] || :last
        db_page.template = Cardboard::Template.find_by(identifier: id.to_s)
        db_page.update_attributes!(page.slice(:title, :parent_id)) 

        self.populate_parts(page[:parts], db_page)
      end

      for remove_page in Cardboard::Page.all.map(&:identifier) - pages.map{|k,v|k.to_s}
        Cardboard::Page.where(identifier: remove_page).first.destroy
      end
    end

    def self.populate_parts(page_parts, db_page)
      # called from the page controller
      page_parts ||= {}
      page_parts.each do |id, part|
        db_part = db_page.parts.where(identifier: id.to_s).first_or_create!
        self.populate_fields(part[:fields], db_part)
      end
      # for remove_part in db_page.parts.map(&:identifier) - page_parts.map{|k,v|k.to_s}
      #   db_page.parts.where(identifier: remove_part).first.destroy
      # end
    end

    def self.populate_fields(fields, object)
      fields ||= {}
      fields.each do |id, field|
        db_field = Field.where(identifier: id.to_s, object_with_field: object).first_or_initialize
        db_field.type = "Cardboard::Field::#{(field[:type] || "string").camelize}"
        db_field.seeding = true
        begin
          db_field.update_attributes!(field.select{|k,v| ["default", "value"].include?(k)}) 
        rescue Exception => e
          # Output validation errors
          puts "-- ERROR --"
          puts e
          puts "#{db_field.identifier}: #{db_field.value_uid || field[:value] || field[:default] || "nil"}"
          puts "-----------"
        end
      end

      #remove fields no longer in the seed file
      # for remove_field in object.fields.map(&:identifier) - fields.map{|k,v|k.to_s}
      #   object.fields.where(identifier: remove_field).first.destroy
      # end
    end

    def self.populate_settings(settings)
      if settings
        db_settings = Cardboard::Setting.first_or_create
        db_settings.update_attributes!(template: settings)
        self.populate_fields(settings, db_settings)
      end
      Cardboard::Setting.add("company_name", type: "string", default:  Cardboard.application.site_title, seeding: true)
    end
    
  end
end