class RenameIexStockSymbolToSymbolInTransactions < ActiveRecord::Migration[7.1]
  def change
    rename_column :transactions, :iex_stock_symbol, :symbol
  end
end
