class WatchlistController < ApplicationController
  # before action: user auth [fr: applications controller]

  # GET /watchlist
  def index
    @watchlist_data = []

    stock_symbols = JSON.parse(File.read(Rails.root.join('data', 'stock_symbols.json')))

    stock_symbols.each do |stock|
      symbol = stock['symbol']
      quote_data = IexStockService.fetch_quote(symbol)
      logos = IexStockService.fetch_logo(symbol)
      charts = IexStockService.fetch_chart(symbol)

      @watchlist_data << {
        symbol: symbol,
        latest_price: quote_data.latest_price,
        company_name: quote_data.company_name,
        logo: logos.url,
        chart: charts
      }
    end

    render json: @watchlist_data
  rescue StandardError => e
    render json: { error_message: "Failed to fetch symbol details: #{e.message}" }, status: :internal_server_error
  end

    # GET /watchlist/:symbol
    def show
      symbol = params[:symbol]
      quote_data = IexStockService.fetch_quote(symbol)
      ohlc_data = IexStockService.fetch_ohlc(symbol)
      historical_prices = IexStockService.fetch_historical_prices(symbol)
      logos = IexStockService.fetch_logo(symbol)
      charts = IexStockService.fetch_chart(symbol)
      news = IexStockService.fetch_news(symbol)
  
      render json: {
        symbol: symbol,
        latest_price: quote_data.latest_price,
        company_name: quote_data.company_name,
        ohlc: {
          close: ohlc_data.close,
          open: ohlc_data.open,
          high: ohlc_data.high,
          low: ohlc_data.low
        },
        historical_prices: historical_prices,
        logo: logos.url,
        chart: charts,
        news: news.first
      }
    rescue StandardError => e
      render json: { error_message: "Failed to fetch symbol details: #{e.message}" }, status: :internal_server_error
    end

end