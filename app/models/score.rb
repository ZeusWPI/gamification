class Score
  attr_accessor :person, :points

  def initialize(person, points)
    @person = person
    @points = points
  end

  def self.all
    github = Github.new
    contributions = Hash.new 0

    # Fill hash with amount of commits per contributor for every repo
    github.repos.list(org: 'ZeusWPI').each do |repo|
      github.repos.contributors('ZeusWPI', repo.name).each do |cont|
        contributions[cont.login] += cont.contributions
      end
    end

    # Convert hash to list of Score objects
    scores = Array.new
    contributions.each do |person, commits|
      scores.push(Score.new(person, commits))
    end

    scores.sort_by! { |score| - score.points }
    return scores
  end
end
