class TransactionsController < ApplicationController
  # before action: user auth [fr: applications controller]

  # GET /transactions/index
  def index
    transactions = current_user.transactions.order(created_at: :desc)
    
    if (transactions == [])
      return render json: { message: 'No transactions found' }, status: :not_found
    end

    render json: TransactionSerializer.new(transactions).serializable_hash
  end

  # GET /transactions/show
  def show
    # if user does not own the transaction, return 404
    transaction = current_user.transactions.find(params[:id])

    render json: TransactionSerializer.new(transaction).serializable_hash

  rescue ActiveRecord::RecordNotFound => e
    render json: { message: 'Transaction not found' }, status: :not_found
  end

  # POST /transactions/buy
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

  # POST /transactions/sell
  def sell
    ## Check if user has enough shares to sell
    if current_user.stocks.find_by(symbol: transaction_params[:symbol]).quantity < transaction_params[:quantity]
      return render json: { message: 'Insufficient shares to sell' }, status: :unprocessable_entity
    end

    ## Sell shares
    transaction = Transaction.sell_shares!(current_user, transaction_params)

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
