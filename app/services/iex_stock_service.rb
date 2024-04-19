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

  def self.fetch_ohlc(symbol)
    @client.ohlc(symbol)
  end

  def self.fetch_historical_prices(symbol)
    @client.historical_prices(symbol, {range: '5d'})
  end

  def self.fetch_logo(symbol)
    @client.logo(symbol)
  end
end