# == Schema Information
#
# Table name: coders
#
#  id              :integer          not null, primary key
#  github_name     :string(255)      not null
#  full_name       :string(255)
#  avatar_url      :string(255)
#  reward_residual :integer          default(0), not null
#  bounty_residual :integer          default(0), not null
#  commits         :integer          default(0), not null
#  additions       :integer          default(0), not null
#  modifications   :integer          default(0), not null
#  deletions       :integer          default(0), not null
#  bounty_score    :integer          default(0), not null
#  other_score     :integer          default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#  github_url      :string(255)
#

require 'faker'

FactoryGirl.define do
  factory :coder do
    github_name { Faker::Internet.user_name }
    full_name   { Faker::Name.name }
    avatar_url  { Faker::Avatar.image }
    github_url  { "example.com/#{github_name}" }
  end
end
