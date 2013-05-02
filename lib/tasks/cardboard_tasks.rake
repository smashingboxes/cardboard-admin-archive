require 'rabl'

Rake::Task['db:seed'].enhance [:cardboard_seed]


# Seed!
task :cardboard_seed => :environment do
  AdminUser.create(email: "michael@smashingboxes.com", password: "1234567890", password_confirmation: "1234567890") if AdminUser.first.nil?

  Cardboard::Page.create(title: "index", path: "/") if Cardboard::Page.root.nil?



  @pages = Cardboard::Page.all
  db_hash = Rabl::Renderer.new('pages_json', @pages, :view_path => Cardboard::Engine.root.join('lib'), :format => 'hash').render

  begin
    file_hash = YAML.load(ERB.new(File.read(Rails.root.join('config', 'pages.yaml'))).result).with_indifferent_access
  rescue Errno::ENOENT => e
    puts "Error: You must first create a pages.yaml file in your application config folder"
  end

  file_hash[:pages].each do |id, page|

    db_page = Cardboard::Page.where(identifier: id.to_s).first_or_initialize
    db_page.update_attributes!(page.filter(:title, :parent_id), :without_protection => true) 

    (page[:parts] || {}).each do |id, part|
      db_part = db_page.parts.where(identifier: id.to_s).first_or_initialize
      db_part.update_attributes!(part.filter(:repeatable), :without_protection => true) 

      db_part.subparts.first_or_create! 

      db_part.subparts.each do |db_part|

        #add new fields
        (part[:fields] || {}).each do |id, field|
          field.reverse_merge!(type: "string")
          db_field = db_part.fields.where(identifier: id.to_s).first_or_initialize
          db_field.seeding = true
          db_field.update_attributes!(field, :without_protection => true) 
        end
      end
      
      #remove ones no longer in the seed file
      for remove_field in db_part.fields.map(&:identifier) - part[:fields].map{|k,v|k.to_s}  
        db_part.fields.where(identifier: remove_field).first.destroy
      end
    end
  end

  db_settings = Cardboard::Setting.first_or_create
  (file_hash[:settings] || {}).each do |id, field|
    field.reverse_merge!(type: "string")
    db_field = db_settings.fields.where(identifier: id.to_s).first_or_initialize
    db_field.seeding = true
    db_field.update_attributes!(field, :without_protection => true) 
  end
  for remove_field in db_settings.fields.map(&:identifier) - file_hash[:settings].map{|k,v|k.to_s} - ["company_name"] 
    db_settings.fields.where(identifier: remove_field).first.destroy
  end
  Cardboard::Setting.add("company_name", type: "string", default: Rails.application.class.name.split("::").first.titlecase, position_position: 0)
  Cardboard::Setting.add("google_analytics", type: "string", position_position: 1)

end

