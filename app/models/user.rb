class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  before_save :email_confirmed, if: :confirmed_at_changed?
  has_one :wallet, dependent: :destroy
  after_create :create_wallet_after_signup

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: { pending_trader: 0, trader: 1, admin: 2 }
  # trader = approved trader
  # feat: if may approved trader, do we need to include rejected traders here sa role?
  # or covered na ng pending trader? 

  scope :pending, -> { where(role: :pending_trader, confirmed_email: :true) }

  validates :email, :first_name, :last_name, :birthday, presence: true
  validates :username, presence: true, uniqueness: true

  private

  def email_confirmed
    self.confirmed_email = true
  end

end
  private

  def create_wallet_after_signup
    if role == 0
      Wallet.create(user_id: id, balance: 50000)
    end
  end
end
