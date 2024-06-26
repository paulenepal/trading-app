class StocksController < ApplicationController
  # before action: user auth [fr: applications controller]
  include CachedStockFetchers

  # GET /stocks
  def index
    stocks = current_user.stocks.valid_assets
    logos = stocks.map { |stock| {
      symbol: stock.symbol,
      logo: fetch_cached_logo(stock.symbol).url
    } }.uniq { |stock| stock[:symbol] }
    if stocks.any?
      render json: {
        status: { code: 200, message: 'Assets successfully retrieved!' },
        data: stocks.map { |stock| StockSerializer.new(stock).serializable_hash[:data][:attributes] },
        logo: logos
      }
    else
      render json: { message: 'User has no assets' }
    end
  end

  # GET /stocks/:id
  def show
    stock = current_user.stocks.find_by(id: params[:id])
    render json: {
      status: { code: 200, message: 'Asset details successfully retrieved!' },
        data: StockSerializer.new(stock).serializable_hash[:data][:attributes]
    }
  end

  # GET /stocks/search?q=
  def search
    symbol = params[:q]
    if symbol.present?
      stocks = current_user.stocks.search_by_symbol(symbol)
      render json: {
        status: { code: 200, message: 'Search completed.' },
        data: stocks.map { |stock| StockSerializer.new(stock).serializable_hash[:data][:attributes] }
      }
    else
      render json: { message: "No matching symbol found."}
    end
  end

end