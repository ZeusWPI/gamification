describe BountiesController, type: :controller do
  #include Devise::TestHelpers

  before :each do
    @issue = create :issue
    @coder = create :coder, bounty_residual: 100
    sign_in @coder
  end

  it 'correctly sets current user' do
    expect(subject.current_coder).to eq(@coder)
  end

  context 'bounty' do
    before :each do
      # Place a bounty
      put :update_or_create,
        bounty: { issue_id: @issue, absolute_value: 10 },
        format: :coffee
    end

    it 'is placed' do
      expect(@issue.bounties.count).to eq(1)
    end

    it 'has correct bounty value' do
      expect(@issue.total_bounty_value).to eq(10)
    end

    it 'was paid for by issuer' do
      @coder.reload
      expect(@issue.total_bounty_value).to eq(10)
      expect(@coder.bounty_residual).to eq(90)
    end

    it 'updates its value on update' do
      put :update_or_create,
        bounty: { issue_id: @issue, absolute_value: 20 },
        format: :coffee
      expect(@issue.total_bounty_value).to eq(20)
    end

  end

  context 'dumb coder' do

    it 'cannot place bounties with insufficient bounty points' do
      put :update_or_create,
        bounty: { issue_id: @issue, absolute_value: 110 },
        format: :coffee
      expect(@coder.bounty_residual).to eq(100)
      expect(@issue.total_bounty_value).to eq(0)
    end

    it 'cannot place bounties with negative value' do
      put :update_or_create,
        bounty: { issue_id: @issue, absolute_value: -10 },
        format: :coffee
      expect(@coder.bounty_residual).to eq(100)
      expect(@issue.total_bounty_value).to eq(0)
    end

    it 'cannot place bounties with non-numeric value' do
      put :update_or_create,
        bounty: { issue_id: @issue, absolute_value: 'A' },
        format: :coffee
      expect(@coder.bounty_residual).to eq(100)
      expect(@issue.total_bounty_value).to eq(0)
    end
  end

  context 'claimed issue' do
    before :each do
      # first claim
      @first_claimant = create :coder
      @issue.assignee = @first_claimant
      put :update_or_create,
        bounty: { issue_id: @issue, absolute_value: 20 },
        format: :coffee
      @issue.close
    end

    it 'has a claimed bounty' do
      expect(
        Bounty.where(issue: @issue).where.not(claimed_at: nil).count
      ).to eq(1)
    end

    context 'when reopened' do
      before :each do
        # Reopen and put a second bounty
        @issue.closed_at = nil
        put :update_or_create,
          bounty: { issue_id: @issue, absolute_value: 20 },
          format: :coffee
      end

      it 'has a claimed bounty' do
        expect(@issue.bounties.where.not(claimed_at: nil).count).to eq(1)
      end

      it 'has an unclaimed bounty' do
        expect(@issue.bounties.where(claimed_at: nil).count).to eq(1)
      end

      context 'and claimed again' do
        before :each do
          @second_claimant = create :coder
          @issue.assignee = @second_claimant
          @issue.close
        end

        it 'rewarded first claimant' do
          expect(@first_claimant.claimed_value).to eq(20)
        end

        it 'rewarded second claimant' do
          expect(@second_claimant.claimed_value).to eq(20)
        end
      end
    end
  end
end
