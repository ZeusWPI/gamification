require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gamification
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # , '~> 1.2'


    # Organisation to track
    config.organisation = 'ZeusWPI'

    config.repository_filters = {
      # only: [ 'gamification', 'Haldis' ]
      except: [
        'glowing-octo-dubstep',
        'VPW-voorbereiding-2015',
        'VPW-voorbereiding-2014',
        'contests',
        'Bestuurstaakjes',
        'SumoRoboComp',
        'kaggle-rta',
        'manage-user',
        'website-manage',
        'errbit'
      ]
      # private: false
    }

    # Total bounty value
    config.total_bounty_value = 5000

    # Addition score factor
    config.addition_score_factor = 10

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    # CORS headers
    config.middleware.insert_before 0, Rack::Cors do
      allow do
          origins /localhost(:\d+)?/, 'zeus.ugent.be'
          resource '*', :headers => :any, :methods => [:get, :options]
        end
    end
  end
end
