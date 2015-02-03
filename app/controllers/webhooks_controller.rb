class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    event = request.headers['X-Github-Event']
    if Hooker.methods(false).include?(event.to_sym) # whitelist methods
      json = JSON.parse request.request_parameters['payload']
      Hooker.send(event, json)
      head :created
    else
      head :ok
    end
  end

  class Hooker
    def self.push(json)
      repo = find_repository json
      repo.pull

      json['commits'].each do |commit|
        Commit.register_from_sha repo, commit['id']
      end
    end

    def self.issues(json)
      # get issue
      repo = find_repository json
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

    private
    def self.find_repository json
      repo_name  = json['repository']['name']
      org_name = json['repository']['owner']['name']
      org = Organisation.find_by name: org_name
      Repository.find_by name: repo_name, organisation: org
    end
  end
end
