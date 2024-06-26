class Admin::UserApprovalsController < ApplicationController
  before_action :check_authorization

  # GET "/admin/user_approvals"
  def index
    users = User.pending
    render json: {
      status: {code: 200, message: 'Pending Traders retrieved successfully.'},
      data: users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
    }
  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  # PATCH "/admin/user_approvals/:id"
  def update
    user = User.find(params[:id])
    user.update(role: :trader)

    UserMailer.welcome_email(user).deliver_now

    render json: user, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  private

  def check_authorization
    raise User::NotAuthorized unless current_user.admin?
  end

end
