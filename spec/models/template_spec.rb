require 'rails_helper'

RSpec.describe Cardboard::Template, type: :model do
  subject(:template) { build :template }

  it { is_expected.to be_valid }
end
