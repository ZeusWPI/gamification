# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

describe Repository do
  it 'has a valid factory' do
    expect(create :repository).to be_valid
  end
end
