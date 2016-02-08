class IndustriesController < ApplicationController
  def show
    @industry = Industry.find(params[:id])
    @company_ids = CompanyToIndustry.where(industry_id: @industry.id)
    @companies = Company.where(id: @company_ids.pluck(:company_id))
  end
end
