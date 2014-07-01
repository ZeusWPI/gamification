# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

github = Github.new
coders = Hash.new

# Get contributor statistics for every repo
github.repos.list(org: 'ZeusWPI').each do |repo|
  # Add amount of commits to the corresponding Coder objects in `coders`. Make
  # new Coder objects along the way.
  github.repos.contributors('ZeusWPI', repo.name).each do |cont|
    Rails.logger.debug(repo.name + ': ' + cont.login + ' committed')
    if coders.has_key?(cont.login)
      coders[cont.login].commits += cont.contributions
    else
      coders[cont.login] = Coder.new(github_name: cont.login,
                                     avatar_url: cont.avatar_url,
                                     commits: cont.contributions,
                                     additions: 0,
                                     modifications: 0,
                                     deletions: 0,
                                     bounty_score: 0,
                                     other_score: 0)
    end
  end

  # Add amount of line additions, changes and deletions to the corresponding
  # Coder objects.
  github.repos.stats.contributors('ZeusWPI', repo.name).each do |cont|
    Rails.logger.debug(repo.name + ': ' + cont.author.login + ' ACDd')
    coders[cont.author.login].additions += cont.weeks.map(&:a).sum
    coders[cont.author.login].modifications += cont.weeks.map(&:c).sum
    coders[cont.author.login].deletions += cont.weeks.map(&:d).sum
  end
end

# Calculate reward and bounty points according to the total score,
# and save all newly created Coder objects.
coders.values.each do |coder|
  score = coder.total_score
  coder.reward_residual = score
  coder.bounty_residual = score
  coder.save!
end
