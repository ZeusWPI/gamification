require 'faker'

FactoryGirl.define do
  factory :issue do
    sequence :number
    title  { Faker::Lorem.sentence }
    github_url { "example.org/issues/#{number}" }
    opened_at { Faker::Date.backward 30 }

    association :issuer, factory: :coder
    repository
  end
end
