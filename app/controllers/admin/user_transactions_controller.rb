class Admin::UserTransactionsController < ApplicationController
  before_action :authenticate_admin

  # Placeholder for Admin User Story #7
  # Need serializer for User Transactions
  # def index
  #   @user_transactions = UserTransaction.all
  #   render json: {
  #     status: {code: 200, message: 'All User Transactions retrieved successfully.'},
  #     data: @user_transactions.map { |transaction| UserTransactionSerializer.new(transaction).serializable_hash[:data][:attributes] }
  #   }
  # end

  private

  def authenticate_admin
    unless current_user.admin?
      render json: { error: 'Access denied' }, status: :forbidden
    end
  end
end
