require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gamification
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brussels'
    # autoload lib files
    config.autoload_paths << Rails.root.join('lib')

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

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

    # Backport from Rails 4.2: custom configurations
    # Just remove this block when upgrading from 4.1.8 to 4.2
    if Rails.version == '4.1.8'
      class Custom
        def initialize
          @configurations = Hash.new
        end

        def method_missing(method, *args)
          if method =~ /=$/
            @configurations[$`.to_sym] = args.first
          else
            @configurations.fetch(method) {
              @configurations[method] = ActiveSupport::OrderedOptions.new
            }
          end
        end
      end

      config.x = Custom.new
    else
      warn('Remove this backport at config/application:62-84')
    end
  end
end
