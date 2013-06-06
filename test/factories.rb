require 'factory_girl'

FactoryGirl.define do
  factory :admin_user do
    sequence(:email) {|n| "#{Faker::Internet.email}#{n}"}
    password Faker::Lorem.characters(10)
  end

  factory :page, class: Cardboard::Page do 
    sequence(:identifier) { |n| "page#{n}" }
  end

  factory :page_part, class: Cardboard::PagePart do
    sequence(:identifier) { |n| "page_part#{n}" }
  end

  factory :boolean_field, class: Cardboard::Field::Boolean do
    sequence(:identifier) { |n| "boolean_field#{n}" }
  end
  factory :date_field, class: Cardboard::Field::Date do
    sequence(:identifier) { |n| "date_field#{n}" }
  end
  factory :decimal_field, class: Cardboard::Field::Decimal do
    sequence(:identifier) { |n| "decimal_field#{n}" }
  end
  factory :external_link_field, class: Cardboard::Field::ExternalLink do
    sequence(:identifier) { |n| "external_link_field#{n}" }
  end
  factory :file_field, class: Cardboard::Field::File do
    sequence(:identifier) { |n| "file_field#{n}" }
  end
  factory :image_field, class: Cardboard::Field::Image do
    sequence(:identifier) { |n| "image_field#{n}" }
  end
  factory :integer_field, class: Cardboard::Field::Integer do
    sequence(:identifier) { |n| "integer_field#{n}" }
  end
  factory :resource_link_field, class: Cardboard::Field::ResourceLink do
    sequence(:identifier) { |n| "resource_link_field#{n}" }
  end
  factory :rich_text_field, class: Cardboard::Field::RichText do
    sequence(:identifier) { |n| "rich_text_field#{n}" }
  end
  factory :string_field, class: Cardboard::Field::String do
    sequence(:identifier) { |n| "string_field#{n}" }
  end
end
