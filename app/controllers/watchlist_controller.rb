class WatchlistController < ApplicationController
  before_action :authenticate_user!

    def index
      @quote_data = []
  
      stock_symbols = JSON.parse(File.read(Rails.root.join('data', 'stock_symbols.json')))
  
      stock_symbols.each do |stock|
        symbol = stock['symbol']
        quote_data = IexStockService.fetch_quote(symbol)
        @quote_data << {
          symbol: symbol,
          latest_price: quote_data.latest_price,
          company_name: quote_data.company_name,
        }
      end
  
      render json: @quote_data
    rescue StandardError => e
      render json: { error_message: "Failed to fetch quote details: #{e.message}" }, status: :internal_server_error
    end

    def ohlc
      @ohlc_data = []

      stock_symbols = JSON.parse(File.read(Rails.root.join('data', 'stock_symbols.json')))

      stock_symbols.each do |stock|
        symbol = stock['symbol']
        ohlc_data = IexStockService.fetch_ohlc(symbol)
        @ohlc_data << {
          symbol: symbol,
          close: ohlc_data.close,
          open: ohlc_data.open,
          high: ohlc_data.high,
          low: ohlc_data.low
        }
      end
  
      render json: @ohlc_data
    rescue StandardError => e
      render json: { error_message: "Failed to fetch stock OHLC details: #{e.message}" }, status: :internal_server_error
    end

    def historical
      @historical_data = []

      stock_symbols = JSON.parse(File.read(Rails.root.join('data', 'stock_symbols.json')))

      stock_symbols.each do |stock|
        symbol = stock['symbol']
        historical_data = IexStockService.fetch_historical_prices(symbol)
        @historical_data << {
          symbol: symbol,
          prices: historical_data.first
        }
      end
  
      render json: @historical_data
    rescue StandardError => e
      render json: { error_message: "Failed to fetch stock historical price details: #{e.message}" }, status: :internal_server_error
    end

    def logo
      @logo = []

      stock_symbols = JSON.parse(File.read(Rails.root.join('data', 'stock_symbols.json')))

      stock_symbols.each do |stock|
        symbol = stock['symbol']
        logo = IexStockService.fetch_logo(symbol)
        @logo << {
          symbol: symbol,
          logo: logo.url
        }
      end
  
      render json: @logo
    rescue StandardError => e
      render json: { error_message: "Failed to fetch stock logo details: #{e.message}" }, status: :internal_server_error
    end

  # def show
  #   @client = IEX::Api::Client.new
  #   @symbol = params[:symbol]
  #   @quote_data = @client.quote(@symbol)

  #   if @quote_data
  #     render json: { symbol: @quote_data.symbol, latest_price: @quote_data.latest_price, company_name: @quote_data.company_name }
  #   else
  #     render json: { error_message: "Failed to fetch quote for symbol #{@symbol}" }, status: :not_found
  #   end

  #   @quote_data
  # end
end