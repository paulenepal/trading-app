class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: { pending_trader: 0, trader: 1, admin: 2 }
  # trader = approved trader
  # feat: if may approved trader, do we need to include rejected traders here sa role?
  # or covered na ng pending trader? 

  scope :pending, -> { where(role: :pending_trader) } # [chore] refactor: need to include scope here na dapat ung confirmed emails lang makikita ni admin sa pending trader

  validates :email, :first_name, :last_name, :birthday, presence: true
  validates :username, presence: true, uniqueness: true

end