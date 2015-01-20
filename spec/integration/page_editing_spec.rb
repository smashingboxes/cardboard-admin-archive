require 'rails_helper'

describe 'Page editing', type: :request do
    before do
      cardboard_yml = <<EOS
---
pages:
  home:
    title: Welcome
    parts:
      intro:
        fields:
          text:
            type: string
            default: default text
            label: ok
            required: 'true'
            hint: this is a hint
            placeholder: Text
          image:
            type: image
            default: CrashTest.jpg
      slideshow:
        repeatable: true
        fields:
          image:
            type: image
            required: 'true'
          desc:
            required: true
            type: string
EOS

      Cardboard::Seed.populate_pages YAML.load(cardboard_yml).with_indifferent_access[:pages]
      user = create(:admin_user)
      login_as user, scope: :admin_user
      visit cardboard.edit_page_path(Cardboard::Page.root)
    end

    it 'should see an error if a required field is submitted empty' do
      fill_in 'page_title', with: ''
      find_button('Save').click
      expect(page).to have_css '.page_title.error'
      expect(page).to have_content "can't be blank"
    end

    it 'should see an error if a repeatable part is submitted with an empty required field', js: false do
      fill_in 'page_parts_attributes_0_fields_attributes_0_value', with: 'Hello'
      find('.btn.add_fields').click
      find_button('Save').click
      expect(page).to have_css '.alert-danger'
    end
end
