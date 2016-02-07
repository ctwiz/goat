class Api::CompaniesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def classification
    @company = Company.find(params[:company_id])
    @sector = Sector.find_by(name: params[:sector])

    unless @sector
      @sector = Sector.create(name: params[:sector])
    end

    @industry = Industry.find_by(name: params[:industry], sector_id: @sector.id)
    unless @industry
      @industry = Industry.create(name: params[:industry], sector_id: @sector.id)
    end

    @cti = CompanyToIndustry.find_by(company_id: @company.id, industry_id: @industry.id)
    unless @cti
      @cti = CompanyToIndustry.create(company_id: @company.id, industry_id: @industry.id)
    end
    render json: @cti
  end
end
