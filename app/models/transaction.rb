class Transaction < ApplicationRecord
  belongs_to :user
  validates :symbol, presence: true
  validates :transaction_type, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }

  def self.buy_shares!(current_user, transaction_attributes)
    ActiveRecord::Base.transaction do 
      total_amount = transaction_attributes[:quantity] * transaction_attributes[:price]
      transaction = current_user.transactions.build(transaction_attributes)
      transaction.total_amount = total_amount
      transaction.save!

      current_user.transactions.create!(transaction_attributes)

      stock = current_user.stocks.find_or_initialize_by(symbol: transaction_attributes[:symbol])
      stock.quantity += transaction_attributes[:quantity]
      stock.save!
    end
  end

  def self.sell_shares!(current_user, transaction_attributes)
    ActiveRecord::Base.transaction do 
      current_user.transactions.create!(transaction_attributes)

      stock = current_user.stocks.find_or_initialize_by(symbol: transaction_attributes[:symbol])
      stock.quantity -= transaction_attributes[:quantity]
      stock.save!
    end
  end

end
