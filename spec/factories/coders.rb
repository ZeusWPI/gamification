require 'faker'

FactoryGirl.define do
  factory :coder do |c|
    c.github_name { Faker::Internet.user_name }
    c.full_name   { Faker::Name.name }
    c.avatar_url  { Faker::Avatar.image }
    c.github_url  { "example.com/#{github_name}" }
  end
end
