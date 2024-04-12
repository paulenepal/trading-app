class WatchlistController < ApplicationController
  # before_action :authenticate_user!

  def show
    symbol = params[:symbol]
    iex_stock_service = IexStockService.new(IexClient)
    quote_data = iex_stock_service.fetch_quote(symbol)

    if quote_data
      render json: { latest_price: quote_data.latest_price }
    else
      render json: { error_message: "Failed to fetch quote for symbol #{symbol}" }, status: :not_found
    end
  end
  
end