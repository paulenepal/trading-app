class Admin::UserTransactionsController < ApplicationController
  before_action :check_authorization

  # GET admin/user_transactions
  def index
    @user_transactions = Transaction.all
    render json: {
      status: {code: 200, message: 'All User Transactions retrieved successfully.'},
      data: @user_transactions.map { |transaction| TransactionSerializer.new(transaction).serializable_hash[:data][:attributes] }
    }
  end

  private

  def check_authorization
    raise User::NotAuthorized unless current_user.admin?
  end
end
