FactoryGirl.define do
  factory :bounty do
    value { rand 100 }
    issue
    association :issuer, factory: :coder

      factory :claimed_bounty do
        association :claimant, factory: :coder
        claimed_at { Faker::Date.backward 30 }
        claimed_value { absolute_value }
      end
  end
end
