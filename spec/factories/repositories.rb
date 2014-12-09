require 'faker'

FactoryGirl.define do
  factory :repository do
    user { Faker::Internet.user_name }
    name { Faker::Lorem.word }
  end
end

