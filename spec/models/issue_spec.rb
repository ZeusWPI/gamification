# == Schema Information
#
# Table name: issues
#
#  id            :integer          not null, primary key
#  github_url    :string(255)      not null
#  number        :integer          not null
#  title         :string(255)      default("Untitled"), not null
#  issuer_id     :integer          not null
#  repository_id :integer          not null
#  labels        :text             not null
#  body          :text
#  assignee_id   :integer
#  milestone     :string(255)
#  opened_at     :datetime         not null
#  closed_at     :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

describe Issue do
  before :each do
    @issue = create :issue
  end

  it 'has a valid factory' do
    expect(create :issue).to be_valid
  end

  context 'with bounties' do
    before :each do
      @claimant = create :coder
      @bounty = create :bounty, issue: @issue
      @issue.assignee = @claimant
    end

    it 'claims bounties when closed' do
      @issue.close
      @bounty.reload
      expect(@bounty.claimed_at).to be
      expect(@bounty.claimant).to eq(@claimant)
    end
  end
end
