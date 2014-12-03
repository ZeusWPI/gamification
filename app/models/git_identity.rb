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

class GitIdentity < ActiveRecord::Base
  belongs_to :coder
end
