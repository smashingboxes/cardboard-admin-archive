$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cardboard/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cardboard"
  s.version     = Cardboard::VERSION
  s.authors     = ["Michael Elfassy", "SmashingBoxes"]
  s.email       = ["michael@smashingboxes.com"]
  s.homepage    = "TODO"
  s.summary     = "CMS made simple"
  s.description = "TODO: Description of Cardboard."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_dependency "pg"
  s.add_dependency "activerecord-postgres-hstore"
  s.add_dependency "stringex"
  s.add_dependency "turbo-sprockets-rails3" #remove when upgrading to rails4
  s.add_dependency "stringex"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "minitest-rails"
  s.add_development_dependency "minitest-rails-capybara"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "binding_of_caller"
end
