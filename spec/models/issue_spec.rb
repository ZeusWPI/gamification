# == Schema Information
#
# Table name: issues
#
#  id            :integer          not null, primary key
#  github_url    :string(255)      not null
#  number        :integer          not null
#  open          :boolean          not null
#  title         :string(255)      default("Untitled"), not null
#  body          :text(255)
#  issuer_id     :integer          not null
#  labels        :text             not null
#  assignee_id   :integer
#  milestone     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  repository_id :integer
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
      create :bounty, issue: @issue
      @issue.assignee = create :coder
    end

    it 'claims bounties when closed' do
      @issue.close
      expect(@issue.bounties.map(&:claimant)).to all(be)
    end
  end
end
