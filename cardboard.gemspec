# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cardboard/version"

Gem::Specification.new do |s|
  s.name        = "cardboard-cms"
  s.license     = "MIT"
  s.version     = Cardboard::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Elfassy", "Smashing Boxes"]
  s.email       = ["michael@smashingboxes.com"]
  s.homepage    = "http://smashingboxes.com"
  s.summary     = "Rails CMS made simple"
  s.description = "Rails CMS made simple"

  # s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.files         = `git ls-files`.split("\n").sort - %w(.rvmrc .gitignore)
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  #don't forget to require them in lib/cardboard/engine.rb
  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "stringex"
  s.add_dependency "sass-rails", '>= 4.0.0'
  s.add_dependency 'slim', '>= 1.3.8'
  s.add_dependency "jquery-rails"
  s.add_dependency 'bootstrap-sass', '>= 2.2'
  s.add_dependency 'bootstrap-wysihtml5-rails'
  s.add_dependency 'bootstrap-datepicker-rails'
  s.add_dependency 'font-awesome-sass-rails',  '>= 3.0.0.1'
  s.add_dependency 'simple_form', '>= 3.0.0.rc'
  s.add_dependency 'kaminari'
  s.add_dependency 'inherited_resources'
  s.add_dependency 'ranked-model'
  s.add_dependency 'cocoon'
  s.add_dependency 'gon'
  s.add_dependency 'rack-cache'
  s.add_dependency 'dragonfly'
  s.add_dependency 'chronic'
  s.add_dependency 'ransack'
  s.add_dependency 'rack-pjax'
  s.add_dependency 'decorators'
  s.add_dependency 'jquery-ui-rails'

  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "minitest-rails"
  s.add_development_dependency "minitest-rails-capybara"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'devise'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'sdoc'
end
