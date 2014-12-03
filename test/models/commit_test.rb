# == Schema Information
#
# Table name: commits
#
#  id            :integer          not null, primary key
#  coder_id      :integer
#  repository_id :integer
#  sha           :string(255)
#  additions     :integer
#  deletions     :integer
#  date          :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class CommitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
