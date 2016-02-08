class Company < ActiveRecord::Base
  has_many :earnings, dependent: :destroy

  has_one :company_to_industry
  has_one :industry, through: :company_to_industry

  def earning
    self.earnings.order('reporting_date DESC').limit(1).first
  end
end
