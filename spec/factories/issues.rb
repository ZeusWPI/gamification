# == Schema Information
#
# Table name: issues
#
#  id            :integer          not null, primary key
#  github_url    :string(255)      not null
#  number        :integer          not null
#  open          :boolean          not null
#  title         :string(255)      default("Untitled"), not null
#  body          :text(255)
#  issuer_id     :integer          not null
#  labels        :text             not null
#  assignee_id   :integer
#  milestone     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  repository_id :integer
#

require 'faker'

FactoryGirl.define do
  factory :issue do
    sequence :number
    title  { Faker::Lorem.sentence }
    github_url { "example.org/issues/#{number}" }
    opened_at { Faker::Date.backward 30 }

    association :issuer, factory: :coder
    repository
  end
end
