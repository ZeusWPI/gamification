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

describe Repository do
  it 'has a valid factory' do
    expect(create :repository).to be_valid
  end
end
