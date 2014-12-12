# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Github accessor
$github = Github.new oauth_token: Rails.application.secrets.github_token,
                     auto_pagination: true
