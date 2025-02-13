class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :account_number, null: false, unique: true
      t.string :pin, null: false
      t.decimal :balance, precision: 10, scale: 2, default: 0.0
      t.timestamps
    end
  end
end
