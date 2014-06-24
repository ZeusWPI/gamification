class Score
  attr_accessor :person, :points, :avatar

  def initialize(person, points, avatar)
    @person = person
    @points = points
    @avatar = avatar
  end

  def self.all
    github = Github.new
    contributions = Hash.new

    # Fill hash with amount of commits per contributor for every repo
    github.repos.list(org: 'ZeusWPI').each do |repo|
      github.repos.contributors('ZeusWPI', repo.name).each do |cont|
        if contributions.has_key?(cont.login)
          contributions[cont.login].points += cont.contributions
        else
          contributions[cont.login] = Score.new(cont.login, cont.contributions, cont.avatar_url)
        end
      end
    end

    return contributions.values.sort_by { |score| - score.points }
  end
end
