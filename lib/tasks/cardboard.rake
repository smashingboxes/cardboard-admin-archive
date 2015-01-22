require Cardboard::Engine.root.join('lib/cardboard/helpers/seed.rb')

# Seed!
task 'cardboard:seed' => :environment do
  puts 'Seeding Cardboard ...'
  begin
    file_hash = YAML.load(ERB.new(File.read(Rails.root.join('config', 'cardboard.yml'))).result).try(:with_indifferent_access)
  rescue Errno::ENOENT => e
    puts 'Error: You must first create a cardboard.yml file in your application config folder'
  end

  if file_hash
    Cardboard::Seed.populate_pages file_hash[:pages]
    Cardboard::Seed.populate_templates file_hash[:templates]
    Cardboard::Seed.populate_settings file_hash[:settings]
  end
end
