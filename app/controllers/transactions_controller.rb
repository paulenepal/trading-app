class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def buy
    transaction = Transaction.buy_shares!(current_user, transaction_params)

    if transaction
      render json: {
        status: { code: 200, message: 'Successfully added shares to assets' },
        data: TransactionSerializer.new(transaction).serializable_hash[:data][:attributes]
      }
    else
      render json: { message: 'Failed to buy shares' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def sell
    transaction = Transaction.sell_shares!(current_user, transaction_attributes)

    if transaction
      render json: {
        status: { code: 200, message: 'Successfully sold shares' },
        data: TransactionSerializer.new(transaction).serializable_hash[:data][:attributes]
      }
    else
      render json: { message: 'Failed to sell shares' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private

  def transaction_params
    params.require(:transaction).permit(:user_id, :symbol, :price, :quantity, :transaction_type)
  end

end
