require 'faker'

FactoryGirl.define do
  factory :coder do
    github_name { Faker::Internet.user_name }
    full_name   { Faker::Name.name }
    avatar_url  { Faker::Avatar.image }
    github_url  { "example.com/#{github_name}" }
  end
end
