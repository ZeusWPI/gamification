# == Schema Information
#
# Table name: git_identities
#
#  id         :integer          not null, primary key
#  name       :text
#  email      :text
#  coder_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class GitIdentityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
