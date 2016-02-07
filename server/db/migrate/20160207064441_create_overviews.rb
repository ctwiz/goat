class CreateOverviews < ActiveRecord::Migration
  def change
    create_table :overviews do |t|
      t.integer :company_id

      t.string :source

      t.integer :open

      t.integer :range_hi
      t.integer :range_lo

      t.integer :f2_wk_hi
      t.integer :f2_wk_lo

      t.integer :market_cap
      t.integer :p_e

      t.integer :div
      t.integer :yield

      t.integer :eps
      t.integer :shares
      t.integer :beta

      t.integer :inst_own

      t.timestamps null: false
    end
  end
end
