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

  # GET /user_balances/{id}
  def show
    transaction = current_user.transactions.find(params[:id])
    render json: TransactionSerializer.new(transaction).serializable_hash
  end

  # POST /user_balances/withdraw_balance?amount=5000
  def add_balance
    current_user.balance += BigDecimal(params[:amount])
    current_user.save!
    render json: {
      status: { code: 200, message: "Successfully deposited #{params[:amount]} to account." },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }
  end

  # POST /user_balances/withdraw_balance?amount=5000
  def withdraw_balance
    if current_user.balance < BigDecimal(params[:amount])
      render json: { message: 'Insufficient balance' }, status: :unprocessable_entity
      return
    end
    current_user.balance -= BigDecimal(params[:amount])
    current_user.save!
    render json: {
      status: { code: 200, message: "Successfully withdrawn #{params[:amount]} from account." },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }
  end

  private

  def check_authorization
    raise User::NotAuthorized unless current_user.admin? || current_user.trader?
  end
end
