require 'factory_girl'

FactoryGirl.define do
  factory :url, class: Cardboard::Url do
    sequence(:path) { |n| "path/#{n}" }
    sequence(:slug) { |n| "path_#{n}" }
  end
end
