describe Bounty do

  before :each do
    @issuer = create :coder
    @issue = create :issue
    @bounty = create :bounty, issue: @issue, issuer: @issuer, value: 100
  end

  it 'has a valid factory' do
    expect(@bounty).to be_valid
  end

  it 'refunds bounty points when issue was not claimed' do
    @bounty.claim
    expect(@issuer.bounty_residual).to eq(100)
  end

  it 'refunds bounty points when claimant is issuer' do
    @issue.assignee = @issuer
    @bounty.claim
    expect(@issuer.bounty_residual).to eq(100)
  end

  context 'when bounty is claimed' do

    before :each do
      @claimant = create :coder
      @issue.assignee = @claimant
      @bounty.claim
    end

    it 'sets claimed time' do
      expect(@bounty.claimed_at).to be
    end

    it 'sets claimed value' do
      expect(@bounty.claimed_value).to eq(100)
    end

    it 'sets claimant' do
      expect(@bounty.claimant).to eq(@claimant)
    end
  end

end
