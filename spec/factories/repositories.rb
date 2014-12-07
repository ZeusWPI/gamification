require 'faker'

FactoryGirl.define do
  factory :repository do |r|
    r.user { Faker::Internet.user_name }
    r.name { Faker::Lorem.word }
  end
end

