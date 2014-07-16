require "test_helper"

describe "Seeding" do
  before do
    DatabaseCleaner.clean
    @file_hash = {
      home:{
        title: "Welcome",
        position: 0,
        parts:{
          intro:{
            position: 1,
            fields:{ 
              text:{
                type: "string",
                default: "default text",
                label: "ok",
                required: "true",
                hint: "this is a hint",
                placeholder: "Text"
              }
            }
          },
          slideshow:{
            repeatable: true,
            position: 0,
            fields:{
              image:{
                type: "image",
                default: "CrashTest.jpg"
              },
              desc:{
                type: "string"
              }
            }
          }
        }
      },

      about_us:{
        parts:{
          about:{
            fields:{
              description:{
                type: "rich_text"
              }
            }
          }
        }
      }
    }.with_indifferent_access
  end
  describe 'Pages' do
    before do
      Cardboard::Seed.populate_templates(@file_hash)
      @template = Cardboard::Template.first
      @page = @template.pages.build
    end

    it "Should have a template" do
      assert_equal @file_hash[:home][:parts], Cardboard::Template.find_by(:identifier => "home").fields
      assert_equal @file_hash[:home][:title], Cardboard::Template.find_by(:identifier => "home").name
    end

    describe 'Modified yml file' do
      before do
        @file_hash.delete(:about_us)
        @file_hash[:home][:parts].delete(:slideshow)
        @file_hash[:home][:parts][:intro][:fields].delete(:text)
        Cardboard::Seed.populate_templates(@file_hash)
      end

      it 'Should remove old templates' do
        skip "removing old templates does not appear to be implemented"
        assert_nil Cardboard::Template.where(:identifier => "about_us").first
        assert_equal 1, Cardboard::Template.count
      end
    end
  end

  describe 'Settings' do
  end
end
