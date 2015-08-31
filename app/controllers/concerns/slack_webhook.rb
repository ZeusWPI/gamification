require 'httparty'
require 'active_record_extensions'

module SlackWebhook
  include HTTParty

  def self.publish_bounty(bounty)
    message = "<#{bounty.issuer.base_uri}|#{bounty.issuer.github_name}> "\
      "plaatste <#{bounty.base_uri}|#{bounty.value} bountypunten> op "\
      "<#{bounty.issue.repository.base_uri}|#{bounty.issue.repository.name}>"\
      '#'\
      "<#{bounty.issue.github_url}|#{bounty.issue.number}: #{bounty.issue.title}>"

    hook_url = Rails.application.secrets.slack_hook_url
    post(hook_url, body: JSON.dump(text: message)) if hook_url
  end
end
