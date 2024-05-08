class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  before_save :email_confirmed, if: :confirmed_at_changed?
  # after_create :pre_deposit_balance
  # has_one :wallet, dependent: :destroy
  # after_create :create_wallet_after_signup
  has_many :transactions, dependent: :destroy
  has_many :stocks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: { pending_trader: 0, trader: 1, admin: 2 }

  scope :pending, -> { where(role: :pending_trader, confirmed_email: :true) }
  scope :traders, -> { where(role: ['pending_trader', 'trader']).order(created_at: :asc) }

  validates :email, :first_name, :last_name, :birthday, presence: true
  validates :username, presence: true, uniqueness: true
  
  def minimum_age
    minimum_age = 18
    today = Date.today
    if birthday.present?
      age = today.year - birthday.year
      age -= 1 if today.month < birthday.month || (today.month == birthday.month && today.day < birthday.day)
      age >= minimum_age
    else
      false
    end
  end

  private

  def email_confirmed
    self.confirmed_email = true
  end

  
end

