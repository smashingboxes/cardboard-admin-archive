require "test_helper"

describe "Page editing integration" do
  before do
    user = FactoryGirl.create(:admin_user)
    login_as(user, :scope => :admin_user)
    visit cardboard.edit_page_path(Cardboard::Page.root)
  end

  it 'should see an error if a required field is submitted empty' do
    fill_in "page_title", with: ""
    find_button('Save').click
    assert page.has_css?(".page_title.error")
    assert page.has_content?("can't be blank")
  end

  it 'should see an error if a repeatable required field is submitted empty' do
    binding.pry
    find_css(".btn.add_fields").click
    find_button('Save').click
    
  end


  it 'should be able to add multiple parts for repeatable sections' do
  end

  it 'should be able to upload images for image fields' do
  end

end