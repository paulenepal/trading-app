class Transaction < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :iex_stock_symbol, presence: true
  validates :transaction_type, presence: true
end
