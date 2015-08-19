require 'httparty'
require 'active_record_extensions'


module SlackWebhook
  include HTTParty
  HOOK_URL = 'https://hooks.slack.com/services/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'

  def self.publish_bounty(bounty)
    message = "<#{bounty.issuer.base_uri}|#{bounty.issuer.github_name}> "\
      "plaatste <#{bounty.base_uri}|#{bounty.value} bountypunten> op "\
      "<#{bounty.issue.repository.base_uri}|#{bounty.issue.repository.name}>"\
      "#"\
      "<#{bounty.issue.github_url}|#{bounty.issue.number}: #{bounty.issue.title}>"

    response = post(HOOK_URL, {body: JSON.dump({text: message})})
  end
end
