require 'rails_helper'

RSpec.describe Cardboard::Url, type: :model do
  subject(:url) { build :url }

  it { is_expected.to be_valid }
end


# require "test_helper"
#
# describe Cardboard::Url do
#   before do
#     @url = Cardboard::Url.new
#   end
#
#   it "must be valid" do
#     @url.path = "/some/path/to/somewhere"
#     @url.slug = "some_awesome_content_page"
#     @url.valid?.must_equal true
#   end
# end
