class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    event = request.headers['X-Github-Event']
    if Hooker.methods(false).include?(event.to_sym) # whitelist methods
      payload = request.request_parameters['payload']
      return head :bad_request unless payload
      json = JSON.parse payload
      Hooker.send(event, json)
      head :created
    else
      head :ok
    end
  end

  class Hooker
    def self.push json
      org = Organisation.find_by name: json['repository']['owner']['name']
      repo = Repository.find_by name: json['repository']['name'],
                                organisation: org
      repo.pull

      json['commits'].each do |commit|
        Commit.register_from_sha repo, commit['id']
      end
    end

    def self.issues json
      # get issue
      org = Organisation.find_by name: json['repository']['owner']['login']
      repo = Repository.find_by name: json['repository']['name'],
                                organisation: org
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

    def self.repository json
      org = Organisation.find_by name: json['repository']['owner']['login']
      return unless org

      case json['action']
      when 'created'
        Repository.create name: json['repository']['name'], organisation: org
      end
    end
  end
end
