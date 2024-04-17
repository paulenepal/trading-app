class WatchlistController < ApplicationController
  before_action :authenticate_user!

  # [wip]

  def show
    @client = IEX::Api::Client.new
    @symbol = params[:symbol]
    @quote_data = @client.quote(@symbol)

    if @quote_data
      render json: { symbol: @quote_data.symbol, latest_price: @quote_data.latest_price, company_name: @quote_data.company_name }
    else
      render json: { error_message: "Failed to fetch quote for symbol #{@symbol}" }, status: :not_found
    end

    @quote_data
  end
end