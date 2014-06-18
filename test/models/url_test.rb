require "test_helper"

describe Url do
  before do
    @url = Url.new
  end

  it "must be valid" do
    @url.valid?.must_equal true
  end
end
