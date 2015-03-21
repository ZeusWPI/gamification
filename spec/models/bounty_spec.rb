# == Schema Information
#
# Table name: bounties
#
#  id            :integer          not null, primary key
#  value         :integer          not null
#  issue_id      :integer          not null
#  issuer_id     :integer          not null
#  claimant_id   :integer
#  claimed_value :integer
#  claimed_at    :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

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

    it 'cannot be claimed again' do
      contender = create :coder
      @issue.assignee = contender
      @bounty.claim
      expect(@bounty.claimant).to eq(@claimant)
    end

    it 'clears its bounty value' do
      expect(@bounty.value).to eq(0)
    end
  end

  context 'with scaled value' do

    before :each do
      @limit = Rails.application.config.total_bounty_value
      @bounty.update value: @limit * 2
      @assignee = create :coder
      @bounty.issue.assignee = @assignee
    end

    it 'has a scaled value' do
      @bounty.update value: @limit * 2
      expect(@bounty.absolute_value).to eq(@limit)
    end

    it 'rewards a scaled value' do
      @bounty.claim
      expect(@assignee.reward_residual).to eq(@limit)
    end

    it 'rewards a scaled amount of bounty points' do
      @bounty.claim
      expect(@assignee.bounty_residual).to eq(@limit * 2)
    end
  end

end
