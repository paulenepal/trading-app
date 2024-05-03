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
      historical_prices: fetch_cached_historical_prices(symbol),
      chart: fetch_cached_chart(symbol),
      news: fetch_cached_news(symbol).first,
      ceo: fetch_cached_company(symbol).ceo,
      description: fetch_cached_company(symbol).description,
      employees: fetch_cached_company(symbol).employees,
      website: fetch_cached_company(symbol).website,
      exchange: fetch_cached_company(symbol).exchange
    }
    
    render json: @stock_data
  rescue StandardError => e
    render json: { error_message: "Failed to fetch symbol details: #{e.message}" }, status: :internal_server_error
  end

  def top
    @watchlist_data = Rails.cache.fetch("watchlist/top", expires_in: CACHE_EXP_QUOTE) do
      fetch_watchlist_data
    end

    top_watchlist = @watchlist_data.sort_by { |stock| stock[:change_percent] }.first(10)
    sorted_top_watchlist = top_watchlist.sort_by { |stock| stock[:change_percent] }.reverse

    render json: sorted_top_watchlist
  rescue StandardError => e
    render json: { error_message: "Failed to fetch symbol details: #{e.message}" }, status: :internal_server_error
  end

  def news
    # @news = fetch_cached_news()
    # map news from data/stock_symbols.json 

    symbolData = JSON.parse(File.read('data/stock_symbols.json'))
    @news = symbolData.map do |symbol|
      fetch_cached_news(symbol['symbol']).first
    end
    
    render json: @news
  rescue StandardError => e
    render json: { error_message: "Failed to fetch symbol news: #{e.message}" }, status: :internal_server_error
  end

end