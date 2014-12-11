require 'faker'

FactoryGirl.define do
  factory :repository do
    organisation
    name { Faker::Lorem.word }
  end
end

