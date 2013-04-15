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

  for page in file_hash[:pages]
    id = page.delete(:id)
    db_page = Cardboard::Page.where(identifier: id).first_or_initialize
    db_page.update_attributes!(page.filter(:title, :parent_id), :without_protection => true) 

    for part in page[:parts] || []
      id = part.delete(:id)
      db_part = db_page.parts.where(identifier: id).first_or_initialize
      db_part.update_attributes!(part.filter(:parent_id), :without_protection => true) 

      #add new fields
      for f in part[:fields] || []
        field = f.dup
        id = field.delete(:id)
        db_field = db_part.fields.where(identifier: id).first_or_initialize
        db_field.update_attributes!(field.reverse_merge!(type: "string"), :without_protection => true) 
      end

      #remove ones no longer in the seed file
      for remove_field in db_part.fields.map(&:identifier) - part[:fields].map{|x|x[:id]}  
        db_part.fields.where(identifier: remove_field).first.destroy
      end
    end

  end

end

