# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest' do
  # with Minitest::Unit
  watch(%r|^test/(.*)\/?(.*)_test\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }
  watch(%r|^test/factories\.rb|)    { "test" }

  # with Minitest::Spec
  # watch(%r|^spec/(.*)_spec\.rb|)
  # watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  # watch(%r|^spec/spec_helper\.rb|)    { "spec" }

  # Rails 3.2
  watch(%r|^app/controllers/cardboard/(.*)\.rb|) { |m| "test/controllers/#{m[1]}_test.rb" }
  watch(%r|^app/helpers/cardboard/(.*)\.rb|)     { |m| "test/helpers/#{m[1]}_test.rb" }
  watch(%r|^app/models/cardboard/(.*)\.rb|)      { |m| "test/models/#{m[1]}_test.rb" }  
  
  watch(%r|^lib/cardboard/helpers/seed\.rb|)   { "test/integration/seeding_test.rb" }

end
