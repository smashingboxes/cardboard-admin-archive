require 'test_helper'

#TODO: get, seo, parent_url_options

describe Cardboard::Field do
  before do
    @part = build :page_part
  end

  it "should accept valid boolean values" do
    @field = build :boolean_field
    assert_equal true, @field.save
    assert_equal false, @field.update_attributes(:value => "")
    ["t", "1", "true", true].each do |val|
      puts val
      assert_equal true, @field.update_attributes(:value => val)
      assert_equal true, @field.value
    end
    [nil,"f", "0", "false", false].each do |val|
      puts val
      assert_equal true, @field.update_attributes(:value => val)
      assert_equal false, @field.value
    end
    assert_equal false, @field.update_attributes(:value => "somehting_bad")
  end

  it "should accept valid date values" do
    @field = build :date_field
    assert_equal true, @field.save
    assert_equal false, @field.save
    assert_equal true, @field.update_attributes(value: "1900-01-01")
    assert_equal Time.new("1900", "01", "01"), @field.value
  end


end