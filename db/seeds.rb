# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Rails.application.config.organisations.each do |name|
  org = Organisation.find_or_create_by name: name
  org.fetch_repositories
end

Rails.application.config.repositories.each do |repo|
  org = Organisation.find_or_create_by name: repo[:org]
  Repository.register org, repo[:name]
end
