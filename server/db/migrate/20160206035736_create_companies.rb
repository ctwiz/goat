class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :stock_symbol
      t.string :market_cap
      t.timestamps null: false
    end
  end
end
