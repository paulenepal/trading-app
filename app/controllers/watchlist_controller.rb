class WatchlistController < ApplicationController
  # before action: user auth [fr: applications controller]
  include CachedStockFetchers

  def index
    @watchlist_data = Rails.cache.fetch("watchlist/data", expires_in: CACHE_EXP_QUOTE) do
      fetch_watchlist_data
    end
    render json: @watchlist_data
  rescue StandardError => e
    render json: { error_message: "Failed to fetch symbol details: #{e.message}" }, status: :internal_server_error
  end

  def show
    symbol = params[:symbol]
    @stock_data = {
      symbol: symbol,
      latest_price: fetch_cached_quote(symbol).latest_price,
      company_name: fetch_cached_quote(symbol).company_name,
      change: fetch_cached_quote(symbol).change,
      change_percent: fetch_cached_quote(symbol).change_percent_s,
      logo: fetch_cached_logo(symbol).url,
      ohlc: fetch_cached_ohlc(symbol),
      historical_prices: fetch_cached_historical_prices(symbol),
      chart: fetch_cached_chart(symbol),
      news: fetch_cached_news(symbol).first
    }
    
    render json: @stock_data
  rescue StandardError => e
    render json: { error_message: "Failed to fetch symbol details: #{e.message}" }, status: :internal_server_error
  end

end