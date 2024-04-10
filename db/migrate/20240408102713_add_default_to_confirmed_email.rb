class AddDefaultToConfirmedEmail < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :confirmed_email, from: nil, to: false
  end
end
