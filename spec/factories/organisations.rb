require 'faker'

FactoryGirl.define do
  factory :organisation do
    name { Faker::Internet.user_name }
  end

end
