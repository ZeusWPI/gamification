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

require 'test_helper'

class CommitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
