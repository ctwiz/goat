class Company < ActiveRecord::Base
  has_many :earnings, dependent: :destroy

  has_one :company_to_industry
  has_one :industry, through: :company_to_industry
end
