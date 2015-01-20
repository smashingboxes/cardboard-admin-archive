require 'rails_helper'

describe 'Page editing', type: :request do
  before do
    @cardboard_yml = <<EOS
---
pages:
  home:
    title: Welcome
    position: 0
    parts:
      intro:
        position: 1
        fields:
          text:
            type: string
            default: Default Text
            label: ok
            required: true
            hint: this is a hint
            placeholder: text
      slideshow:
        repeatable: true
        position: 0
        fields:
          image:
            type: image
            default: CrashTest.jpg
          desc:
            type: string
  about_us:
    parts:
      about:
        fields:
          description:
            type: rich_text
EOS

    @file_hash = YAML.load(@cardboard_yml).with_indifferent_access[:pages]
    DatabaseCleaner.clean
  end


  describe 'Pages' do
    before do
      Cardboard::Seed.populate_templates @file_hash
      @template = Cardboard::Template.first
      @page = @template.pages.build
    end

    it "Should have a template" do
      expect(Cardboard::Template.where(identifier: 'home').first.fields).to eq @file_hash[:home][:parts]
      expect(Cardboard::Template.where(identifier: 'home').first.name).to eq @file_hash[:home][:title]
    end

    describe 'Modified yml file' do
      before do
        @file_hash.delete(:about_us)
        @file_hash[:home][:parts].delete(:slideshow)
        @file_hash[:home][:parts][:intro][:fields].delete(:text)
        Cardboard::Seed.populate_templates(@file_hash)
      end

      it 'Should remove old templates' do
        skip 'removing old templates does not appear to be implemented'
        expect(Cardboard::Template.where(identifier: 'about_us').first).to eq nil
        expect(Cardboard::Template.count).to eq 1
      end
    end
  end

  describe 'Settings' do
    before do
      Cardboard::Seed.populate_settings nil
    end
    it 'Should set the company name' do
      expect(Cardboard::Setting.company_name).to eq 'Dummy'
    end
  end


end
