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
    def self.push(json)
      repo_name  = json['repository']['name']
      repo_owner = json['repository']['owner']['name']

      repo = Repository.find_by user: repo_owner, name: repo_name
      repo.pull

      json['commits'].each do |commit|
        Commits.register_from_sha repo, commit['id']
      end
    end

    def self.issues(json)
      # get issue
      repo = Repository.find_by name: json['repository']['name'],
                                user: json['repository']['owner']['login']
      issue = Issue.find_or_create_from_hash json['issue'], repo

      case json['action']
        when 'opened', 'reopened'
          issue.update! closed_at: nil
        when 'closed'
          issue.close time: DateTime.parse(json['issue']['closed_at'])
        when 'assigned'
          assignee = Coder.find_by github_name: json['issue']['assignee']['login']
          issue.update! assignee: assignee
        when 'unassigned'
          issue.update! assignee: nil
      end
    end
  end
end
