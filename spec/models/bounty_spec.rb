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

  it 'scales its absolute value with set limit' do
    limit = Rails.application.config.total_bounty_value
    @bounty.update value: limit * 2
    expect(@bounty.absolute_value).to eq(limit)
  end

  context 'claimed by issuer' do

    before :each do
      @issue.assignee = @issuer
      @bounty.claim
    end

    it 'refunds bounty points' do
      expect(@issuer.bounty_residual).to eq(100)
    end

    it 'deletes itself' do
      expect(@bounty.destroyed?).to be_truthy
    end
  end

  context 'when claimed' do

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
