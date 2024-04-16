require 'iex-ruby-client'

IEX::Api.configure do |config|
  config.publishable_token = ENV['IEX_API_PUBLISHABLE_TOKEN']
  # config.secret_token = ENV['IEX_API_SECRET_TOKEN']
  config.endpoint = 'https://cloud.iexapis.com/v1'
  # config.endpoint = 'https://api.iex.cloud/v1'
end

# IEX::Api.configure do |config|
#   config.publishable_token = Rails.application.credentials.iex[:public_key] # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
#   config.secret_token = Rails.application.credentials.iex[:secret_key] # defaults to ENV['IEX_API_SECRET_TOKEN']
#   config.endpoint = 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
# end