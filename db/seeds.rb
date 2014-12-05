# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Rails.application.config.repositories.each do |hash|
  repo = Repository.create user: hash[:user], name: hash[:name]
  repo.clone
  repo.register_commits
  repo.fetch_issues
end
