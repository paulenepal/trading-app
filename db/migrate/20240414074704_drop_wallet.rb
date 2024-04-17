class DropWallet < ActiveRecord::Migration[7.1]
  def change
    drop_table :wallets
  end
end
