# == Schema Information
#
# Table name: bounties
#
#  id             :integer          not null, primary key
#  absolute_value :integer          not null
#  issue_id       :integer          not null
#  issuer_id      :integer          not null
#  claimant_id    :integer
#  claimed_value  :integer
#  claimed_at     :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

describe Bounty do
  before :each do
    @issuer = create :coder
    @issue = create :issue
    @bounty = create :bounty, issue: @issue, issuer: @issuer, absolute_value: 100
  end

  it 'has a valid factory' do
    expect(@bounty).to be_valid
  end

  it 'gets destroyed when valued is 0' do
    @bounty.absolute_value = 0
    @bounty.save
    expect(@bounty).to be_destroyed
  end

  it 'refunds bounty points when issue was not claimed' do
    @bounty.claim!
    expect(@issuer.bounty_residual).to eq(100)
  end

  context 'claimed by issuer' do
    before :each do
      @issue.assignee = @issuer
      @bounty.claim!
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
      @bounty.claim!
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
      @bounty.claim!
      expect(@bounty.claimant).to eq(@claimant)
    end

    it 'clears its bounty value' do
      expect(@bounty.absolute_value).to eq(0)
    end

    it 'does not get destroyed when valued is 0 and is claimed' do
      @bounty.claim!
      expect(@bounty).not_to be_destroyed
      expect(@bounty).to be_valid
    end
  end

  context 'with scaled value' do
    before :each do
      @limit = Rails.application.config.total_bounty_value
      @bounty.update!(absolute_value: @limit * 2)
      @assignee = create :coder
      @bounty.issue.assignee = @assignee
    end

    it 'has a scaled value' do
      expect(@bounty.absolute_value).to eq(2 * @limit)
      expect(@bounty.value).to eq(@limit)
    end

    it 'rewards a scaled value' do
      @bounty.claim!
      expect(@assignee.reward_residual).to eq(@limit)
    end

    it 'rewards a scaled amount of bounty points' do
      @bounty.claim!
      expect(@assignee.absolute_bounty_residual).to eq(2 * @limit)
      expect(@assignee.bounty_residual).to eq(@limit)
    end
  end

  context 'with other bounty points in the running' do
    before :each do
      @limit = Rails.application.config.total_bounty_value
      @issuer.update!(absolute_bounty_residual: @limit - 100)
      @other_coder = create :coder, absolute_bounty_residual: 2 * @limit
    end

    it 'has a rescaled value' do
      expect(@bounty.absolute_value).to eq(100)
      expect(@bounty.value).to eq(33)
    end

    context 'when claimed' do
      before :each do
        @issue.assignee = @other_coder
        @bounty.claim!
      end

      it 'has a claimed value, but no absolute_value' do
        expect(@bounty.absolute_value).to eq(0)
        expect(@bounty.claimed_value).to eq(33)
        expect(@bounty.value).to eq(33)
      end

      context 'and when other bounties come to exist' do
        before :each do
          @other_bounty = create :bounty, absolute_value: 1000
        end

        it 'has a claimed value, but no absolute_value' do
          expect(@bounty.absolute_value).to eq(0)
          expect(@bounty.claimed_value).to eq(33)
          expect(@bounty.value).to eq(33)
        end
      end
    end
  end
end
