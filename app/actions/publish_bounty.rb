class PublishBounty
  attr :bounty

  def initialize(bounty)
    @bounty = bounty
  end

  def call
    Slack.send_text(message)
  end

private

  def message
    "#{author} plaatste #{score} op #{repository} ##{github_issue}: #{title}"
  end

  def author
    link_to(bounty.issuer.github_name, bounty.issuer)
  end

  def score
    [bounty.value, "bountypunt".pluralize(bounty.value)].join(" ")
  end

  def repository
    link_to(bounty.issue.repository.name, bounty.issue.repository)
  end

  def github_issue
    link_to(bounty.issue.number, bounty.issue.github_url)
  end

  def title
    bounty.issue.title
  end

  def link_to(text, object_or_uri)
    uri = ensure_uri(object_or_uri)

    "<#{uri}|#{text}>"
  end

  def ensure_uri(object_or_uri)
    if object_or_uri.respond_to?(:base_uri)
      object_or_uri.base_uri
    else
      object_or_uri
    end
  end

end
