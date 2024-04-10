class Admin::UserApprovalsController < ApplicationController
  before_action :authenticate_admin

  def index
    users = User.pending
    render json: {
      status: {code: 200, message: 'Pending Traders retrieved successfully.'},
      data: users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
    }
  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  def update
    user = User.find(params[:id])
    user.update(role: :trader)
    render json: user, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  private

  def authenticate_admin
    unless current_user.admin?
      render json: { error: 'Access denied' }, status: :forbidden
    end
  end

end