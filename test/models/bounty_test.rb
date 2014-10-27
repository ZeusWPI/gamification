# == Schema Information
#
# Table name: bounties
#
#  id         :integer          not null, primary key
#  value      :integer          not null
#  issue_id   :integer          not null
#  coder_id   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class BountyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
