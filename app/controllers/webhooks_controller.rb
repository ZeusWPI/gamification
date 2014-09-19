class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    event = request.headers['X-Github-Event']
    if Hooker.methods(false).include?(event.to_sym) # whitelist methods
      Hooker.send(event,request.request_parameters)
      head :created
    else
      head :ok
    end
  end

  class Hooker
    @@github = Github.new oauth_token: Rails.application.secrets.github_token

    def self.push(json)
      repo       = json['repository']['name']
      repo_owner = json['repository']['owner']['name']
      json['commits'].each do |commit|
        author = Coder.find_by_github_name(commit['author']['username'])
        if author
          commit = @@github.repos.commits.find user: repo_owner, repo: repo, sha: commit['id']
          author.commits += 1
          author.additions += commit.stats.additions
          author.deletions += commit.stats.deletions
          # TODO: Add points
          author.save
        end
      end
    end

    def self.issues(json)
      issue = Issue.find_by repo: json['repository']['name'], number: json['issue']['number']
      if not issue
        issue = Issue.create_from_hash(json['issue'], json['repository']['name'])
        issue.save!
      end

      case json['action']
        when 'opened', 'reopened'
          issue.update! open: true
        when 'closed'
          issue = Issue.find_by repo: json['repository']['name'], number: json['issue']['number']
          issue.close
        when 'assigned'
          issue = Issue.find_by repo: json['repository']['name'], number: json['issue']['number']
          assignee = Coder.find_by github_name: json['issue']['assignee']['login']
          p issue.inspect
          p assignee.inspect
          issue.update! assignee: assignee
        when 'unassigned'
          issue.update! assignee: nil
      end
    end
  end
end
