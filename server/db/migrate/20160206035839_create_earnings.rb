class CreateEarnings < ActiveRecord::Migration
  def change
    create_table :earnings do |t|
      t.integer :company_id
      t.datetime :reporting_date
      t.string :fiscal_quarter
      t.integer :eps_forecast
      t.integer :estimate_count
      t.datetime :last_year_report_date
      t.integer :last_year_eps
      t.timestamps null: false
    end
  end
end
