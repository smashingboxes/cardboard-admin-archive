require "test_helper"
require Cardboard::Engine.root.join('lib/cardboard/helpers/seed.rb')

describe "Seeding" do
  before do
    DatabaseCleaner.clean
    @file_hash = {
      pages: {
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
                  default: "app/assets/images/CrashTest.jpg"
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
      }
    }.with_indifferent_access
  end
  describe 'Pages' do
    before do
      Cardboard::Seed.populate_pages(@file_hash[:pages])
      @page = Cardboard::Page.root
      @part = @page.parts.first
    end
    it 'Should add pages' do
      assert_equal "home", @page.identifier
      assert_equal 2, Cardboard::Page.count
    end
    it 'Should add parts' do
      assert_equal "intro", @part.identifier
    end
    it 'Should add fields' do
      refute_nil @page.get("intro").fields.where(identifier: "text")
    end
    describe 'Modified yml file' do
      before do
        @file_hash[:pages].delete(:about_us)
        @file_hash[:pages][:home][:parts].delete(:slideshow)
        @file_hash[:pages][:home][:parts][:intro][:fields].delete(:text)
        Cardboard::Seed.populate_pages(@file_hash[:pages])
        @page = Cardboard::Page.root
        @part = @page.parts.first
      end
      it 'Should remove old pages' do
        assert_nil Cardboard::Page.where(:identifier => "about_us").first
        assert_equal 1, Cardboard::Page.count
      end
      it 'Should remove old parts' do
        assert_nil @page.get("slideshow")
        refute_nil @page.get("intro")
      end
      it 'Should remove old fields' do
        assert_nil @page.get("intro").attr("text")
      end
    end
  end
  describe 'Settings' do
  end
end