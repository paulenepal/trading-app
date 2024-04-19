class Stock < ApplicationRecord
  belongs_to :user

  scope :search_by_symbol, -> (symbol) {
    sanitized_symbol = sanitize_sql_like(symbol)
    where("symbol ILIKE ?", "%#{sanitized_symbol}%")
  }

  def profit_loss
    avg_buy = average_buy(symbol)
    return if avg_buy.nil? || latest_price.nil?

    ((avg_buy * quantity) - (latest_price * quantity)).round(2)
  end

  def value
    (latest_price * quantity).round(2)
  end

  def latest_price
    @client = IEX::Api::Client.new
    @quote_data = @client.quote(symbol)
    latest_price = @quote_data.latest_price
  end

  before_save :update_latest_price

  private

  def update_latest_price
    self.latest_price = fetch_latest_price if symbol.present?
  end

  def average_buy(symbol)
    transactions = Transaction.where(symbol: symbol)
    return nil if transactions.empty?

    total_price = transactions.sum(:price)
    total_quantity = self.quantity
  
    total_price / total_quantity.to_f
  end

end
