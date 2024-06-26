class Admin::UsersController < ApplicationController
  before_action :check_authorization
  # chore: refactor responses [keep your code DRY]

  # GET "/admin/users"
  def index
    users = User.traders
    render json: {
      status: {code: 200, message: 'Traders retrieved successfully.'},
      data: users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
    }
  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  # GET "/admin/users/:id"
  def show
    user = User.find(params[:id])
    render json: {
      status: {code: 200, message: 'User details retrieved successfully.'},
      data: UserSerializer.new(user).serializable_hash[:data][:attributes]
    }

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  # POST "/admin/users"
  def create
    new_user = User.new(user_params)
    new_user.password = Rails.application.credentials.user[:default_password]
    new_user.role = :trader # sets role to trader automatically

    if new_user.minimum_age
      if new_user.save
        new_user.update!(confirmed_at: Time.current)
        UserMailer.welcome_email(new_user).deliver_now
        render json: {
          status: {code: 200, message: 'Signed up successfully.'},
          data: UserSerializer.new(new_user).serializable_hash[:data][:attributes]
        }
      else
        render json: {
          status: {message: "User couldn't be created successfully. #{new_user.errors.full_messages.to_sentence}"}
        }, status: :unprocessable_entity
      end
    else
      render json: {
        status: {message: "User must be at least 18 years old."}
      }, status: :unprocessable_entity
    end
  
  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  # PATCH "/admin/users/:id"
  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: {
        status: {code: 200, message: 'User details updated successfully.'},
        data: UserSerializer.new(user).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: {message: "User details couldn't be updated. #{user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  private

  def check_authorization
    raise User::NotAuthorized unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :middle_name, :last_name, :username, :birthday, :confirmed_email, :role, :balance)
  end
end