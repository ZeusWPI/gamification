require 'httparty'
require 'active_record_extensions'

class Slack
  include HTTParty

  def self.send_text(text)
    send_hook(text: text)
  end

  def self.send_hook(options)
    hook_url = Rails.application.secrets.slack_hook_url
    post(hook_url, body: JSON.dump(options)) if hook_url
  end

end
