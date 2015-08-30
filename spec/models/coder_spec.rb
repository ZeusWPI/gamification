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
#

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
        @coder.reward_commit commit
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

  context 'with claimed bounties' do
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
end
