require Cardboard::Engine.root.join('lib/cardboard/helpers/seed.rb')

# Rake::Task['db:seed'].enhance do
#   Rake::Task['cardboard:seed'].invoke
# end


# Seed!
task 'cardboard:seed' => :environment do
  puts "Seeding Cardboard ..."
  begin
    file_hash = YAML.load(ERB.new(File.read(Rails.root.join('config', 'cardboard.yml'))).result).try(:with_indifferent_access)
  rescue Errno::ENOENT => e
    puts "Error: You must first create a cardboard.yml file in your application config folder"
  end


  # Cardboard::Seed.populate_pages(file_hash)
  Cardboard::Seed.populate_templates(file_hash)
  Cardboard::Seed.populate_settings(file_hash) 

end

