# == Schema Information
#
# Table name: bounties
#
#  id            :integer          not null, primary key
#  value         :integer          not null
#  issue_id      :integer          not null
#  issuer_id     :integer          not null
#  claimant_id   :integer
#  claimed_value :integer
#  claimed_at    :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

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
