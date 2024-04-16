class RenameIexStockSymbolToSymbolInStocks < ActiveRecord::Migration[7.1]
  def change
    rename_column :stocks, :iex_stock_symbol, :symbol
  end
end
