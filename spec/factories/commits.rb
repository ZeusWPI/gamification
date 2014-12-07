require 'faker'

FactoryGirl.define do
  factory :commit do |c|
    coder
    repository
    # close enough
    c.sha { Faker::Bitcoin.address }
    c.additions { rand 100 }
    c.deletions { rand 100 }
    c.date { Faker::Date.backward 30 }
  end
end
