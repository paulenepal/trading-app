class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_one :wallet, dependent: :destroy
  after_create :create_wallet_after_signup

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: self

  private

  def create_wallet_after_signup
    if role == 0
      Wallet.create(user_id: id, balance: 50000)
    end
  end
end
