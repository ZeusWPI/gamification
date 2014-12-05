# == Schema Information
#
# Table name: bounties
#
#  id          :integer          not null, primary key
#  value       :integer          not null
#  issue_id    :integer          not null
#  issuer_id   :integer          not null
#  claimant_id :integer
#  claimed_at  :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class BountyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
