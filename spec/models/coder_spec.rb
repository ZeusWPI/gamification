# == Schema Information
#
# Table name: coders
#
#  id              :integer          not null, primary key
#  github_name     :string(255)      not null
#  full_name       :string(255)      default(""), not null
#  avatar_url      :string(255)      not null
#  github_url      :string(255)      not null
#  reward_residual :integer          default(0), not null
#  bounty_residual :integer          default(0), not null
#  other_score     :integer          default(0), not null
#  created_at      :datetime
#  updated_at      :datetime

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

      @addition_score = [10, 20, 12].map do |n|
        Rails.application.config.addition_score_factor *
        Math.log(n + 1)
      end.map(&:round).sum

      @coder.commits.each do |commit|
        @coder.reward_commit! commit
      end
    end

    it 'has a correct addition count' do
      expect(@coder.additions).to eq(42)
    end

    it 'has a correct deletion count' do
      expect(@coder.deletions).to eq(19)
    end

    it 'was granted reward points' do
      expect(@coder.reward_residual).to eq(@addition_score)
    end

    it 'was granted bounty points' do
      expect(@coder.bounty_residual).to eq(@addition_score)
    end

    it 'has a correct score' do
      expect(@coder.score).to eq(@addition_score)
    end
  end

  context 'with claimed bounty' do
    before :each do
      @issue = create :issue, assignee: @coder
      @bounty = create :bounty, issue: @issue, absolute_value: 100
      @bounty.claim
    end

    it 'has a corrent claimed_value stat' do
      expect(@coder.claimed_value).to eq(100)
    end

    it 'has a correct score' do
      expect(@coder.score).to eq(100)
    end

    it 'was granted reward points' do
      expect(@coder.reward_residual).to eq(100)
    end

    it 'was granted bounty points' do
      expect(@coder.bounty_residual).to eq(100)
    end
  end

  context 'with other bounty points in the running' do
    before :each do
      @limit = Rails.application.config.total_bounty_value
      @coder.update!(absolute_bounty_residual: @limit)
      @other_coder = create :coder, absolute_bounty_residual: 2 * @limit
    end

    it 'ensures a correct total amount of bounty points' do
      expect(BountyPoints.total_bounty_points).to almost_eq(3 * @limit)
    end

    it 'has a rescaled bounty residual' do
      expect(@coder.absolute_bounty_residual).to eq(@limit)
      expect(@other_coder.absolute_bounty_residual).to eq(2 * @limit)
      expect(@coder.bounty_residual).to eq((@limit.to_f / 3).round)
      expect(@other_coder.bounty_residual).to eq((2 * @limit.to_f / 3).round)
    end

    context 'with a bounty placed' do
      before :each do
        @issue = create :issue
        @bounty = create :bounty, {
          issue: @issue,
          absolute_value: 0,
          issuer: @coder
        }
        @bounty.update_value!(100)
      end

      it 'ensures total amount of bounty points stays the same' do
        expect(BountyPoints.total_bounty_points).to almost_eq(3 * @limit)
      end

      it 'has a rescaled bounty residual' do
        expect(@coder.bounty_residual).to eq((@limit.to_f / 3).round - 100)
        expect(@coder.absolute_bounty_residual).to almost_eq(((@limit.to_f / 3).round - 100) * 3)
      end

      context 'and self-claimed' do
        before :each do
          @issue.assignee = @coder
          @bounty.claim
        end

        it 'ensures total amount of bounty points stays the same' do
          expect(BountyPoints.total_bounty_points).to almost_eq(3 * @limit)
        end

        it 'has his bounty points refunded' do
          expect(@coder.absolute_bounty_residual).to almost_eq(@limit)
          expect(@coder.bounty_residual).to eq((@limit.to_f / 3).round)
        end
      end

      context 'and claimed by someone else' do
        before :each do
          @issue.assignee = @other_coder
          @bounty.claim
        end

        it 'has attributed reward and bounty points to the other coder' do
          expect(@other_coder.bounty_residual).to eq((2 * @limit.to_f / 3).round + 100)
          expect(@other_coder.absolute_bounty_residual).to almost_eq(((2 * @limit.to_f / 3).round + 100) * 3)
          expect(@other_coder.reward_residual).to eq(100)
        end
      end
    end
  end
end
