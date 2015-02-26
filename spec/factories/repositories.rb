# == Schema Information
#
# Table name: repositories
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  organisation_id :integer          not null
#  hook_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'faker'

FactoryGirl.define do
  factory :repository do
    organisation
    name { Faker::Lorem.word }
  end
end

