class Admin::UsersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_user, only: [:show, :updated]

  # chore 2: refactor responses [keep your code DRY]
  # chore 3: implement UserMailer

  def index
    users = User.all
    render json: {
      status: {code: 200, message: 'Traders retrieved successfully.'},
      data: users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
    }
  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  def show
    # before action here
    render json: {
      status: {code: 200, message: 'User details retrieved successfully.'},
      data: UserSerializer.new(user).serializable_hash[:data][:attributes]
    }

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  def create
    new_user = User.new(user_params)
    # new_user.password = Rails.application.credentials.user.default_password
    new_user.skip_confirmation!  # skips confirmation if user was created by Admin
    new_user.role = :trader # sets role to trader automatically

    if new_user.save
      # UserMailer.with(user: new_user).welcome_email.deliver_now
      render json: {
        status: {code: 200, message: 'Signed up successfully.'},
        data: UserSerializer.new(new_user).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: {message: "User couldn't be created successfully. #{new_user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end

  rescue StandardError => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  def update
    # before action here
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

  def authenticate_admin
    unless current_user.admin?
      render json: { error: 'Access denied' }, status: :forbidden
    end
  end

  def set_user
    user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :middle_name, :last_name, :username, :birthday, :confirmed_email, :role)
  end
end