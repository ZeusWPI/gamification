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
