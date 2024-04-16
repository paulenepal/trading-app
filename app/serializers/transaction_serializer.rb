class TransactionSerializer
  # include JSONAPI::Serializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :user_id, :transaction_type, :symbol, :quantity, :price
end