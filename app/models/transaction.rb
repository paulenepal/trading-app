class Transaction < ApplicationRecord
  belongs_to :user
  validates :symbol, presence: true
  validates :transaction_type, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }

  # TODO :
  # Cannot transact if user is not yet approved

  def self.buy_shares!(current_user, transaction_attributes)
    ActiveRecord::Base.transaction do 
      total_amount = transaction_attributes[:quantity] * transaction_attributes[:price]
      transaction = current_user.transactions.build(transaction_attributes)
      transaction.total_amount = total_amount
      transaction.save!

      if current_user.balance < total_amount
        Rails.logger.error("Insufficient balance to buy shares")
        raise 
      end

      current_user.balance -= total_amount
      current_user.save!

      stock = current_user.stocks.find_or_initialize_by(symbol: transaction_attributes[:symbol])
      stock.quantity += transaction_attributes[:quantity]
      stock.save!

      transaction
    end

  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error Buying Shares: #{e.message}")
    raise
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
