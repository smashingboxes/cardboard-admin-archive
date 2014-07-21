require_relative "../test_helper"

describe Cardboard::Template do
  before do
    @template = Cardboard::Template.new
  end

  it "must be valid" do
    @template.identifier = "valid_identifier1"
    @template.valid?.must_equal true
  end
end
