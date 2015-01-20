require 'factory_girl'

FactoryGirl.define do
  factory :template, class: Cardboard::Template do
    sequence(:identifier) { |n| "template#{n}" }
    fields {
      {
        intro:{
          fields:{
            text:{
              type: "string",
              default: "default text",
              label: "ok",
              required: "true",
              hint: "this is a hint",
              placeholder: "Text"
            },
            image:{
              type: "image",
              default: "CrashTest.jpg"
            }
          }
        },
        slideshow:{
          repeatable: true,
          fields:{
            image:{
              type: "image",
              required: "true"
            },
            desc:{
              required: "true",
              type: "string"
            }
          }
        }
      }.with_indifferent_access
    }
  end
end
