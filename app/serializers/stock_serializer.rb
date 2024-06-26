class StockSerializer
  include JSONAPI::Serializer
  attributes :id, :symbol, :quantity, :latest_price, :profit_loss, :value, :ave_buy

  def latest_price
    object.latest_price
  end

  def profit_loss
    object.profit_loss
  end

  def value
    object.value
  end

  def ave_buy
    object.average_buy
  end
end