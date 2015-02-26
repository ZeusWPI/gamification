# == Schema Information
#
# Table name: organisations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

describe Organisation do
  it 'has a valid factory' do
    expect(create :organisation).to be_valid
  end
end
