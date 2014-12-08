require 'faker'

FactoryGirl.define do
  factory :commit do
    coder
    repository
    sha { Faker::Lorem.characters 30 }
    additions { rand 100 }
    deletions { rand 100 }
    date { Faker::Date.backward 30 }
  end
end
