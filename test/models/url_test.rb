require "test_helper"

describe Cardboard::Url do
  before do
    @url = Cardboard::Url.new
  end

  it "must be valid" do
    @url.path = "/some/path/to/somewhere"
    @url.slug = "some_awesome_content_page"
    @url.valid?.must_equal true
  end
end
