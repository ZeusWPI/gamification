class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  class Hooker
    @@github = Github.new oauth_token: Rails.application.secrets.github_token

    def self.push(params)
      repo       = params['repository']['name']
      repo_owner = params['repository']['owner']['name']
      params['commits'].each do |commit|
        author = Coder.find_by_github_name(commit['author']['username'])
        if author
          commit = @@github.repos.commits.find user: repo_owner, repo: repo, sha: commit['id']
          author.commits += 1
          author.additions += commit.stats.additions
          author.deletions += commit.stats.deletions
          author.save
        end
      end
    end
  end

  def receive
    event = request.headers['X-Github-Event']
    if Hooker.methods(false).include?(event.to_sym) # whitelist methods
      Hooker.send(event,params)
      head :created
    else
      head :ok
    end
  end

end
