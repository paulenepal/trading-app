class ChangeSymbolToStringInTransactions < ActiveRecord::Migration[7.1]
  def change
    change_column :transactions, :symbol, :string
  end
end
