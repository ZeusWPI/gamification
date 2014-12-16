describe BountiesController, type: :controller do

  before :each do
    @issue = create :issue
    @coder = create :coder, bounty_residual: 100
    @request.env["devise.mapping"] = Devise.mappings[:coder]
    sign_in @coder
  end

  context 'authenticated coder' do
    before :each do
      # Place a bounty
      put :update_or_create,
        bounty: { issue_id: @issue, absolute_value: 10 },
        format: :coffee
    end

    it 'correctly sets current user' do
      expect(subject.current_coder).to eq(@coder)
    end

    it 'can place bounties' do
      expect(@issue.bounties.count).to eq(1)
    end

    it 'sets correct bounty value' do
      expect(@issue.total_bounty_value).to eq(10)
    end

    it 'pays for the bounty' do
      @coder.reload
      expect(@issue.total_bounty_value).to eq(10)
      expect(@coder.bounty_residual).to eq(90)
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
end
