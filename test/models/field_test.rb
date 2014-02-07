require 'test_helper'

#TODO: get, seo, parent_url_options

describe Cardboard::Field do
  before do
    
    @template = build :template, fields: {slideshow:{ fields: {
        boolean_field: {type: "boolean"},
        date_field: {type: "date"},
        decimal_field: {type: "decimal"},
        file_field: {type: "file"},
        image_field: {type: "image"},
        integer_field: {type: "integer"},
        rich_text_field: {type: "rich_text"},
        string_field: {type: "string"}
      }}
    }
    @page = build :page, template: @template
    @part = build :page_part, page: @page, identifier: "slideshow"
  end

  it "should accept valid boolean values" do
    @field = build :boolean_field, object_with_field: @part, identifier: "boolean_field"
    # assert_equal true, @field.save
    assert_equal true, @field.update_attributes(:value => "")
    ["t", "1", "true", true].each do |val|
      assert_equal true, @field.update_attributes(:value => val)
      assert_equal true, @field.value
    end
    [nil,"f", "0", "false", false].each do |val|
      assert_equal true, @field.update_attributes(:value => val)
      assert_equal false, @field.value
    end
    assert_equal false, @field.update_attributes(:value => "somehting_bad")
  end

  it "should accept valid date values" do

    @field = build :date_field, object_with_field: @part, identifier: "date_field"
    # assert_equal true, @field.save
    assert_equal true, @field.update_attributes(value: "1900-01-01")
    assert_equal Time.new('1900', '01', '01', '12', '00'), @field.value #chronic dates are at noon by default
  end
  it "should not accept invalid date values" do
    @field = build :date_field, object_with_field: @part, identifier: "date_field"
    # @field.required = true
    assert_equal false, @field.save
    assert_equal false, @field.update_attributes(:value => "")
    assert_equal false, @field.update_attributes(:value => "something")
  end

  it "should accept valid decimal numbers" do
    @field = build :decimal_field, object_with_field: @part, identifier: "decimal_field"
    # assert_equal true, @field.save
    assert_equal true, @field.update_attributes(:value => 1.23)
    assert_equal 1.23, @field.value
    assert_equal true, @field.update_attributes(:value => "1.23")
    assert_equal 1.23, @field.value
  end
  it "should not accept invalid decimal numbers" do
    @field = build :decimal_field, object_with_field: @part, identifier: "decimal_field"
    # @field.required = true
    # assert_equal true, @field.save
    assert_equal false, @field.update_attributes(:value => "")
    assert_equal false, @field.update_attributes(:value => "something")
  end

  it "should not accept invalid files" do
    @field = build :file_field, object_with_field: @part, identifier: "file_field"
    # @field.required = true
    # assert_equal true, @field.save
    
    assert_equal false, @field.update_attributes(:value => "")
    assert_equal nil, @field.value_uid
    #TODO: test file validations
  end

  it "should not accept invalid images" do
    @field = build :image_field, object_with_field: @part, identifier: "image_field"
    # @field.required = true
    # assert_equal true, @field.save
    
    assert_equal false, @field.update_attributes(:value => "")
    assert_equal nil, @field.value_uid
    #TODO: test image validations
  end

  it "should accept valid integer numbers" do
    @field = build :integer_field, object_with_field: @part, identifier: "integer_field"
    # assert_equal true, @field.save
    # @field.required = true
    assert_equal false, @field.update_attributes(:value => "")
    assert_equal false, @field.update_attributes(:value => 1.23)
    assert_equal true, @field.update_attributes(:value => "123")
    assert_equal 123, @field.value
  end

  it "should accept valid rich text" do
    @field = build :rich_text_field, object_with_field: @part, identifier: "rich_text_field"
    # assert_equal true, @field.save
    # @field.required = true
    assert_equal true, @field.update_attributes(:value => "something<script>alert('bad')</script>")
    assert_equal "something", @field.value
  end

  it "should accept valid string" do
    @field = build :string_field, object_with_field: @part, identifier: "string_field"
    # assert_equal true, @field.save
    # @field.required = true
    assert_equal true, @field.update_attributes(:value => "something")
    assert_equal "something", @field.value
    assert_equal false, @field.update_attributes(:value => "")
  end  

end