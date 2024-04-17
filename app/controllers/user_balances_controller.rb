class UserBalancesController < ApplicationController
  before_action :authenticate_user!
  include RackSessionsFix
  respond_to :json

  # GET /user_balances/first_time_free_deposit
  def first_time_free_deposit
    current_user.balance += 10000
    current_user.save!
  end

  # POST /user_balances/add_balance
  def add_balance
    current_user.balance += params[:balance]
    current_user.save!

    render json: {
      status: { code: 200, message: 'Successfully added balance to assets' },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }
  end

  # POST /user_balances/deduct_balance
  def deduct_balance
    current_user.balance -= params[:balance]
    current_user.save!

    render json: {
      status: { code: 200, message: 'Successfully deducted balance from assets' },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }
  end
end
