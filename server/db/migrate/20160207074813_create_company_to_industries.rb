class CreateCompanyToIndustries < ActiveRecord::Migration
  def change
    create_table :company_to_industries do |t|
      t.integer :company_id
      t.integer :industry_id
      t.timestamps null: false
    end
  end
end
