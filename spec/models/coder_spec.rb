describe Coder do

  before :each do
    @coder = create :coder
  end

  it 'has a valid factory' do
    expect(@coder).to be_valid
  end


  context 'with commits' do

    before :each do
      create :commit, coder: @coder, additions: 10, deletions: 4
      create :commit, coder: @coder, additions: 20, deletions: 8
      create :commit, coder: @coder, additions: 12, deletions: 7

      @coder.commits.each do |commit|
        commit.reward!
      end
    end

    it 'has a correct addition count' do
      expect(@coder.additions).to eq(42)
    end

    it 'has a correct deletion count' do
      expect(@coder.deletions).to eq(19)
    end


    it 'was granted reward points' do
      expect(@coder.reward_residual).to eq(42)
    end

    it 'was granted bounty points' do
      expect(@coder.bounty_residual).to eq(42)
    end

    it 'has a correct score' do
      expect(@coder.total_score).to eq(72)
    end
  end


  context 'with claimed bounties' do

    before :each do
      issue = create :issue, assignee: @coder
      bounty = create :bounty, issue: issue, value: 100
      bounty.claim
    end

    it 'has a correct score' do
      expect(@coder.total_score).to eq(100)
    end

    it 'was granted reward points' do
      expect(@coder.reward_residual).to eq(100)
    end

    it 'was granted bounty points' do
      expect(@coder.bounty_residual).to eq(100)
    end

  end

end
