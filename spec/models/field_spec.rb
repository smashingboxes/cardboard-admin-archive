require 'rails_helper'

RSpec.describe Cardboard::Field, type: :model do
  before do
    @template = build :template,
                      fields: {
                        slideshow: {
                          fields: {
                            boolean_field:    { type: 'boolean' },
                            date_field:       { type: 'date' },
                            decimal_field:    { type: 'decimal' },
                            file_field:       { type: 'file' },
                            image_field:      { type: 'image' },
                            integer_field:    { type: 'integer' },
                            rich_text_field:  { type: 'rich_text' },
                            string_field:     { type: 'string' }
                          }
                        }
                      }
    @page = build :page, template: @template
    @part = build :page_part, page: @page, identifier: 'slideshow'
  end

  describe 'boolean_field' do\
    before do
      @field = build :boolean_field, object_with_field: @part, identifier: 'boolean_field'
    end

    describe 'with valid boolean values' do
      ['t', '1', 'true', true].each do |value|
        it "true is saved when #{value.to_s} (#{value.class}) is passed" do
          expect(@field.update_attributes value: value).to be true
          expect(@field.value).to be true
        end
      end

      [nil,'f', '0', 'false', false].each do |value|
        it "false is saved when #{value.to_s} (#{value.class}) is passed" do
          expect(@field.update_attributes value: value).to be true
          expect(@field.value).to be false
        end
      end
    end

    describe 'with invalid a boolean value' do
      it "doesn't save" do
        expect(@field.update_attributes value: 'somehting_bad').to be false
      end
    end
  end

  describe 'date_field' do
    it 'accepts valid date values' do
      @field = build :date_field, object_with_field: @part, identifier: 'date_field'
      # FIXME: Why doesn't this field save? Assertion was commented on
      # https://github.com/smashingboxes/cardboard/commit/5fe8dc221d58fc775133bcf7fbdcd4e3bcb4f1a8
      # Similar lines where are commented along this file.
      # expect(@field.save).to be true
      expect(@field.update_attributes value: '1900-01-01').to be true
      expect(@field.value).to eq Time.new('1900', '01', '01', '12', '00') # 'hronic dates are at noon by default
    end

    it "doesn't accepts invalid date values" do
      @field = build :date_field, object_with_field: @part, identifier: 'date_field'
      expect(@field.save).to be false
      expect(@field.update_attributes value: '').to be false
      expect(@field.update_attributes value: 'something').to be false
    end
  end

  describe 'decimal_field' do
    describe 'with valid values' do
      before do
        @field = build :decimal_field, object_with_field: @part, identifier: 'decimal_field'
      end

      it 'accepts decimal values' do
        expect(@field.update_attributes value: 1.23).to be true
        expect(@field.value).to eq 1.23
      end

      it 'accepts strings that look like decimal values' do
        expect(@field.update_attributes value: '1.23').to be true
        expect(@field.value).to eq 1.23
      end
    end

    describe 'with invalid values' do
      it "it doesn't save non-decimal-looking values" do
        @field = build :date_field, object_with_field: @part, identifier: 'date_field'
        expect(@field.save).to be false
        expect(@field.update_attributes value: '').to be false
        expect(@field.update_attributes value: 'something').to be false
      end
    end
  end

  describe 'file_field' do
    it "doesn't acccept invalid file objects" do
      @field = build :file_field, object_with_field: @part, identifier: 'file_field'
      # @field.required = true
      # assert_equal true, @field.save
      expect(@field.update_attributes value: '').to be false
      expect(@field.value_uid).to be nil
      #TODO: test file validations
    end
  end

  describe 'image_field' do
    it "doesn't acccept invalid image objects" do
      @field = build :image_field, object_with_field: @part, identifier: 'image_field'
      # @field.required = true
      # assert_equal true, @field.save
      expect(@field.update_attributes value: '').to be false
      expect(@field.value_uid).to be nil
      #TODO: test file validations
    end
  end

  describe 'integer_field' do
    before do
      @field = build :integer_field, object_with_field: @part, identifier: 'integer_field'
      # assert_equal true, @field.save
      # @field.required = true
    end

    it 'accepts a valid value' do
      expect(@field.update_attributes value: '123').to be true
      expect(@field.update_attributes value: 123).to be true
    end

    it "doesn't accept a valid value" do
      expect(@field.update_attributes value: '').to be false
      expect(@field.update_attributes value: 1.23).to be false
    end
  end

  describe 'string_field' do
    before do
      @field = build :string_field, object_with_field: @part, identifier: 'string_field'
      # assert_equal true, @field.save
      # @field.required = true
    end

    it 'accepts a valid value' do
      expect(@field.update_attributes value: 'something').to be true
      expect(@field.value).to eq 'something'
    end

    it "doesn't accept a valid value" do
      expect(@field.update_attributes value: '').to be false
    end
  end

end
