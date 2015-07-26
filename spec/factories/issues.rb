# == Schema Information
#
# Table name: issues
#
#  id            :integer          not null, primary key
#  github_url    :string(255)      not null
#  number        :integer          not null
#  title         :string(255)      default("Untitled"), not null
#  issuer_id     :integer          not null
#  repository_id :integer          not null
#  labels        :text             not null
#  body          :text
#  assignee_id   :integer
#  milestone     :string(255)
#  opened_at     :datetime         not null
#  closed_at     :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

require 'faker'

FactoryGirl.define do
  factory :issue do
    sequence :number
    title  { Faker::Lorem.sentence }
    github_url { "example.org/issues/#{number}" }
    opened_at { Faker::Date.backward 30 }
    labels ''

    association :issuer, factory: :coder
    repository
  end
end
