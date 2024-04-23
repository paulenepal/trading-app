class UserController < ApplicationController
  # before action: user auth [fr: applications controller]

  def show
    user = current_user
    render json: {
      status: { code: 200, message: 'User retrieved successfully.' },
      data: UserSerializer.new(user).serializable_hash[:data][:attributes]
    }
  end

end
