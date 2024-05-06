class Stock < ApplicationRecord
  include ActiveSupport::NumberHelper

  belongs_to :user

  scope :search_by_symbol, -> (symbol) {
    sanitized_symbol = sanitize_sql_like(symbol.downcase)
    where("LOWER(symbol) LIKE ?", "%#{sanitized_symbol}%")
  }

  scope :valid_assets, -> { where('quantity >= 1') }

  def profit_loss
    avg_buy = average_buy(symbol)
    return if avg_buy.nil? || latest_price.nil?

    loss = (latest_price * self.quantity) - (avg_buy * self.quantity)
    number_to_currency(loss)
  end

  def value
    number_to_currency(latest_price * self.quantity)
  end

  def latest_price
    quote_data = IexStockService.fetch_quote(symbol)
    latest_price = quote_data.latest_price
    latest_price
  end

  def ave_buy
    avg = average_buy(symbol)
    number_to_currency(avg)
  end

  private

  def average_buy(symbol)
    transactions = Transaction.where(symbol: symbol)
    return nil if transactions.empty?

    total_amount = transactions.sum(:total_amount)
    total_quantity = self.quantity
  
    total_amount / total_quantity
  end

end
