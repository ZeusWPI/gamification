server 'gamification.fkgent.be', user: 'gamification', roles: %w(web app db),
       ssh_options: {
           forward_agent: true,
           auth_methods: ['publickey'],
           port: 2222
       }

set :rails_env, 'production'
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :deploy_to, '/srv/gamification'

set :linked_files, %w(
    config/database.yml
    config/secrets.yml
    config/application.rb
    config/environments/production.rb
    config/initializers/github.rb
    config/initializers/devise.rb
)

#set :default_env, 'RAILS_RELATIVE_URL_ROOT' => '/game'
