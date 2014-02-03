require "test_helper"

describe Template do
  before do
    @template = Template.new
  end

  it "must be valid" do
    @template.valid?.must_equal true
  end
end
