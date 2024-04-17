require 'iex-ruby-client'

class IexStockService
  @client = IEX::Api::Client.new(
    publishable_token: ENV['IEX_API_PUBLISHABLE_TOKEN'],
    secret_token: ENV['IEX_API_SECRET_TOKEN'],
    endpoint: 'https://cloud.iexapis.com/v1'
)

  def self.fetch_quote(symbol)
    @client.quote(symbol)
  end
end