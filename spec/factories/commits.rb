# == Schema Information
#
# Table name: commits
#
#  id            :integer          not null, primary key
#  coder_id      :integer
#  repository_id :integer
#  sha           :string(255)      not null
#  additions     :integer          default(0), not null
#  deletions     :integer          default(0), not null
#  date          :datetime         not null
#  created_at    :datetime
#  updated_at    :datetime
#

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
