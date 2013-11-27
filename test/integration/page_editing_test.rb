require "test_helper"

describe "Page editing integration" do
  before do
    DatabaseCleaner.clean
    @file_hash = {
      pages: {
        home:{
          title: "Welcome",
          parts:{
            intro:{
              fields:{
                text:{
                  type: "string",
                  default: "default text",
                  label: "ok",
                  required: "true", 
                  hint: "this is a hint",
                  placeholder: "Text"
                },
                image:{
                  type: "image",
                  default: "CrashTest.jpg"
                } 
              }
            },
            slideshow:{
              repeatable: true,
              fields:{
                image:{
                  type: "image",
                  required: "true"
                },  
                desc:{
                  required: "true",
                  type: "string"
                }
              }
            }
          }
        }
      }
    }.with_indifferent_access
    Cardboard::Seed.populate_pages(@file_hash)
    user = FactoryGirl.create(:admin_user)
    login_as(user, :scope => :admin_user)
    visit cardboard.edit_page_path(Cardboard::Page.root)
  end

  it 'should see an error if a required field is submitted empty' do
    binding.pry
    fill_in "page_title", with: ""
    find_button('Save').click   
    assert page.has_css?(".page_title.error")   
    assert page.has_content?("can't be blank")
  end

  # it 'should not see an error if a repeatable submitted all empty' do
  #   find(".btn.add_fields").click
  #   find_button('Save').click 
  #   assert page.has_css?("#flash_success"), "ERROR: Should have an success message"
  # end

  it 'should see an error if a repeatable part is submitted with an empty required field' do
    fill_in "page_parts_attributes_1_subparts_attributes_0_fields_attributes_1_value", with: "Hello"
    find(".btn.add_fields").click
    find_button('Save').click
    assert page.has_css?(".alert-error"), "ERROR: Should have an error message"
  end

  it 'should be able to add multiple parts for repeatable sections' do
  end

  it 'should be able to upload images for image fields' do
    
  end

end