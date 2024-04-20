class Stock < ApplicationRecord
  include ActiveSupport::NumberHelper

  belongs_to :user

  scope :search_by_symbol, -> (symbol) {
    sanitized_symbol = sanitize_sql_like(symbol)
    where("symbol ILIKE ?", "%#{sanitized_symbol}%")
  }

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
  end

  def ave_buy
    avg = average_buy(symbol)
    number_to_currency(avg)
  end

  before_save :update_latest_price

  private

  def update_latest_price
    self.latest_price = fetch_latest_price if symbol.present?
  end

  def average_buy(symbol)
    transactions = Transaction.where(symbol: symbol)
    return nil if transactions.empty?

    total_amount = transactions.sum(:total_amount)
    total_quantity = self.quantity
  
    total_amount / total_quantity
  end

end
