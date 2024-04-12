class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.integer :user_id, null: false
      t.decimal :balance, :decimal, precision: 10, scale: 2, default: 0.0

      t.timestamps null: false
    end
  end
end
