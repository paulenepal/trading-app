require 'httparty'

class IexStockService
  def initialize(iex_client)
    @client = iex_client
  end

  def self.fetch_quote(symbol)
    @client.quote(symbol)
  end
end