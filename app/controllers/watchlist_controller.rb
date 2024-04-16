class WatchlistController < ApplicationController
  before_action :authenticate_user!

  # [wip]

  def show
    @symbol = params[:symbol]
    @client = IEX::Api::Client.new(
      secret_token: ENV['IEX_API_SECRET_TOKEN'],
      endpoint: 'https://cloud.iexapis.com/v1'
    )
    @quote_data = @client.quote(@symbol)

    if quote_data
      render json: { symbol: @quote_data.symbol, latest_price: @quote_data.latest_price }
    else
      render json: { error_message: "Failed to fetch quote for symbol #{@symbol}" }, status: :not_found
    end
  end
end