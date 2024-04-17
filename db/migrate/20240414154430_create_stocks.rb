class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :iex_stock_symbol 
      t.integer :quantity, default: 0
      t.references :user, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
