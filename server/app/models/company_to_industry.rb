class CompanyToIndustry < ActiveRecord::Base
  belongs_to :company
  belongs_to :industry
end
