require 'active_support/concern'

module Cardboard

  module Seed
    extend ActiveSupport::Concern

    def self.populate_pages(filehash = nil)
      pages = filehash ? filehash[:pages] : {}
      pages.each do |id, page|

        db_page = Cardboard::Page.where(identifier: id.to_s).first_or_initialize
        db_page.update_attributes!(page.filter(:title, :parent_id)) 

        self.populate_parts(page[:parts], db_page)
      end

      for remove_page in Cardboard::Page.all.map(&:identifier) - pages.map{|k,v|k.to_s}
        Cardboard::Page.where(identifier: remove_page).first.destroy
      end

      Cardboard::Page.create(identifier: "index", path: "/") if Cardboard::Page.root.nil?
    end


    def self.populate_parts(page_parts, db_page)
      page_parts ||= {}
      page_parts.each do |id, part|
        db_part = db_page.parts.where(identifier: id.to_s).first_or_initialize
        db_part.update_attributes!(part.filter(:repeatable))
        db_part.update_attribute :part_position_position, part[:position] || :last

        db_part.subparts.first_or_create! 

        db_part.subparts.each do |db_part|
          self.populate_fields(part[:fields], db_part)
        end
      end
      for remove_part in db_page.parts.map(&:identifier) - page_parts.map{|k,v|k.to_s}
        db_page.parts.where(identifier: remove_part).first.destroy
      end
    end

    def self.populate_fields(fields, object)
      fields ||= {}
      fields.each do |id, field|

        db_field = Field.where(identifier: id.to_s, object_with_field: object).first_or_initialize
        db_field.type = "Cardboard::Field::#{(field[:type] || "string").camelize}"
        db_field.seeding = true
        db_field.position_position = field[:position] || :last
        begin
          db_field.update_attributes!(field.reject{|k,v|k == "type"}) 
        rescue Dragonfly::DataStorage::DataNotFound => e
          puts "ERROR: #{e}"
          puts db_field.attributes.to_s
        end
      end

      #remove fields no longer in the seed file
      for remove_field in object.fields.map(&:identifier) - fields.map{|k,v|k.to_s}
        object.fields.where(identifier: remove_field).first.destroy
      end
    end

    def self.populate_settings(filehash = nil)
      settings = filehash ? filehash[:settings] : nil
      if settings
        db_settings = Cardboard::Setting.first_or_create
        self.populate_fields(settings, db_settings)
      end
      Cardboard::Setting.add("company_name", type: "string", default:  Cardboard.application.site_title, position: 0)
      # Cardboard::Setting.add("google_analytics", type: "string", position: 1)
    end
    
  end
end