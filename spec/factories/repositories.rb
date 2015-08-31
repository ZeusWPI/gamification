# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  github_url :string(255)      not null
#  clone_url  :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

require 'faker'

FactoryGirl.define do
  factory :repository do
    name       { Faker::Lorem.word }
    github_url { "example.com/#{name}" }
    clone_url  { "https://example.com/#{name}.git" }
  end
end
