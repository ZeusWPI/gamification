# Github accessor
Rails.configuration.x.github = Github.new(
  oauth_token: Rails.application.secrets.github_token,
  auto_pagination: true
)
