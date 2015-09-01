class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    event = request.headers['X-Github-Event']
    return head :bad_request unless event

    case event
    when 'push'
      push request.request_parameters
    when 'issues'
      issues request.request_parameters
    when 'repository'
      repository request.request_parameters
    else
      head :ok
    end
  end

  private

  def push(json)
    @owner = json['repository']['owner']['name']
    repo = Repository.find_by name: json['repository']['name']
    return head :ok unless repo && valid_owner?

    repo.pull_or_clone

    if json['commits']
      json['commits'].each do |commit|
        Commit.register_from_sha repo, commit['id']
      end
    end
    head :created
  end

  def issues(json)
    @owner = json['repository']['owner']['login']
    repo = Repository.find_by name: json['repository']['name']
    return head :ok unless repo && valid_owner?

    issue = Issue.find_or_create_from_hash json['issue'], repo

    case json['action']
    when 'opened', 'reopened'
      issue.update! closed_at: nil
    when 'closed'
      issue.close! time: DateTime.rfc3339(json['issue']['closed_at'])
    when 'assigned'
      assignee = Coder.find_by github_name: json['issue']['assignee']['login']
      issue.update! assignee: assignee
    when 'unassigned'
      issue.update! assignee: nil
    else
      return head :ok
    end
    head :created
  end

  def repository(json)
    repo = json['repository']
    @owner = repo['owner']['login']
    return head :ok unless RepoFilters.track?(repo) && valid_owner?

    case json['action']
    when 'created'
      Repository.create_or_update repo
      return head :created
    end

    head :ok
  end

  def valid_owner?
    @owner == Rails.application.config.organisation
  end
end
