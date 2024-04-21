class UserBalancesController < ApplicationController
  # before action: user auth [fr: applications controller]
  before_action :check_authorization

  # TODO:
  # Add transaction type to keep track of deposits and withdrawals

  # GET /user_balances
  def index
    balance = BigDecimal(current_user.balance)

    render json: {
      status: { code: 200, message: 'Success' },
      data: { balance: balance }
    }
  end

  # GET /user_balances/transactions?type=2 or type=3
  def transactions
    if params[:type] == '2' # deposits
      transactions = current_user.transactions.where(transaction_type: 2).order(created_at: :desc)
    elsif params[:type] == '3' # withdrawals
      transactions = current_user.transactions.where(transaction_type: 3).order(created_at: :desc)
    else
      transactions = current_user.transactions.where(transaction_type: [2, 3]).order(created_at: :desc)
    end

    render json: {
      status: { code: 200, message: 'Success' },
      data: { total: transactions.count, transactions: TransactionSerializer.new(transactions).serializable_hash[:data]}
    }
  end

  # GET /user_balances/{id}
  def show
    transaction = current_user.transactions.where(id: params[:id], transaction_type: [2, 3]).first
    
    if transaction.nil?
      render json: { message: 'Transaction not found' }, status: :not_found
      return
    end
    
    render json: {
      status: { code: 200, message: 'Success' },
      data: TransactionSerializer.new(transaction).serializable_hash[:data][:attributes]
    }
  end

  # GET /user_balances/investment
  def investment
    transactions = current_user.transactions.where(transaction_type: 2)

    render json: {
      status: { code: 200, message: 'Success' },
      data: {total: transactions.count, investment: transactions.sum(:price), transactions: TransactionSerializer.new(transactions).serializable_hash[:data]}
    }
  end

  # POST /user_balances/withdraw_balance?amount=5000.00
  def add_balance
    amount_param = BigDecimal(params[:amount])

    if isValidAmount(amount_param) == false
      render json: { message: 'Invalid amount' }, status: :unprocessable_entity
      return
    end
    
    current_user.balance += BigDecimal(params[:amount])
    current_user.save!
    transaction = Transaction.add_balance!(current_user, balances_params, params[:amount])

    render json: {
      status: { code: 200, message: "Successfully deposited #{params[:amount]} to account." },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
      transaction_data: TransactionSerializer.new(transaction).serializable_hash[:data][:attributes]
    }
  end

  # POST /user_balances/withdraw_balance?amount=5000.00
  def withdraw_balance
    amount_param = BigDecimal(params[:amount])

    if isValidAmount(amount_param) == false
      render json: { message: 'Invalid amount' }, status: :unprocessable_entity
      return
    end

    if current_user.balance < amount_param
      render json: { message: 'Insufficient balance' }, status: :unprocessable_entity
      return
    end
    
    current_user.balance -= amount_param
    current_user.save!
    transaction = Transaction.withdraw_balance!(current_user, balances_params, params[:amount])

    render json: {
      status: { code: 200, message: "Successfully withdrawn #{params[:amount]} from account." },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
      transaction_data: TransactionSerializer.new(transaction).serializable_hash[:data][:attributes]
    }
  end

  private

  def check_authorization
    raise User::NotAuthorized unless current_user.admin? || current_user.trader?
  end

  def balances_params # Substitute for Transaction params
    params.permit( :user_id, :transaction_type)
  end

  def isValidAmount(amount)
    amount > 0 && amount < 1000000
  end
end
