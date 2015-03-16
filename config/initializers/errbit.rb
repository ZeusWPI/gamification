Airbrake.configure do |config|
  config.api_key = '347b322e04831db3e24da517849b2a2b'
  config.host    = 'errbit-zeus.ilion.me'
  config.port    = 443
  config.secure  = config.port == 443
end
