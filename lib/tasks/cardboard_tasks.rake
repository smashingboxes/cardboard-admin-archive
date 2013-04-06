require 'rabl'

Rake::Task['db:seed'].enhance [:cardboard_seed]


# Seed!
task :cardboard_seed => :environment do
  Cardboard::User.create(email: "michael@smashingboxes.com", password: "123456", password_confirmation: "123456") if Cardboard::User.first.nil?

  Cardboard::Page.create(title: "index", path: "/") if Cardboard::Page.root.nil?


  begin
    @pages = Cardboard::Page.all
    db_hash = Rabl::Renderer.new('pages_json', @pages, :view_path => Cardboard::Engine.root.join('lib'), :format => 'hash').render

    file_hash = JSON.parse(ERB.new(File.read(Rails.root.join('config', 'pages.json'))).result, {:symbolize_names => true})
    
    add_attributes = {pages: file_hash}.deep_dup
    remove_attributes = {}
    binding.pry
    add_attributes.delete_merge!({pages: db_hash})
        binding.pry

    # pages = YAML.load(File.read(Rails.root.join('config', 'pages.yaml')))
    # old_pages =  Cardboard::Page.all.inject({}) do |h,page|
    #   groups = page.field_groups.all.inject({}) do |h,group|
    #     h.deep_merge!(group.fields.all.inject({}){|h, field| h.deep_merge!(field.name => field.type)})
    #   end
    #   h.merge(page.title => groups , "parent_id" => page.parent_id)
    # end

    
  # for page in pages
  #   Cardboard::Page.where()
  # end
  rescue Errno::ENOENT => e
    puts "Error: You must first create a pages.yaml file in your application config folder"
  end
end

