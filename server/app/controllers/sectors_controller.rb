class SectorsController < ApplicationController
  def index
    @sectors = Sector.order('name ASC').all
  end

  def show
    @sector = Sector.find(params[:id])
    @industries = Industry.where(sector_id: @sector.id).order('name ASC')
    @company_ids = CompanyToIndustry.where(industry_id: @industries.pluck(:id))
    @companies = Company.where(id: @company_ids.pluck(:company_id))
    @earnings = Earning.find_by_sql("SELECT *, (eps_forecast - last_year_eps) AS diff,
                                     (eps_forecast - last_year_eps)*companies.market_cap AS diff_mcap 
                                     FROM earnings,
                                     companies ON earnings.company_id = companies.id
                                     WHERE companies.id in (#{@companies.pluck(:id).join(",")})
                                     ORDER BY reporting_date ASC")

  end

  def diff
    @sector = Sector.find(params[:sector_id])
    @industries = Industry.where(sector_id: @sector.id).order('name ASC')
    @company_ids = CompanyToIndustry.where(industry_id: @industries.pluck(:id))
    @companies = Company.where(id: @company_ids.pluck(:company_id))

    @earnings = Earning.find_by_sql("SELECT *, (eps_forecast - last_year_eps) AS diff,
                                     (eps_forecast - last_year_eps)*companies.market_cap AS diff_mcap 
                                     FROM earnings,
                                     companies ON companies.id = earnings.company_id
                                     WHERE earnings.company_id in (#{@companies.pluck(:id).join(",")})
                                     ORDER BY diff DESC")
    render "show"
  end

  def diff_mcap
    @sector = Sector.find(params[:sector_id])
    @industries = Industry.where(sector_id: @sector.id).order('name ASC')
    @company_ids = CompanyToIndustry.where(industry_id: @industries.pluck(:id))
    @companies = Company.where(id: @company_ids.pluck(:company_id))
    @earnings = Earning.find_by_sql("SELECT *, (eps_forecast - last_year_eps) as diff,
                                     (eps_forecast - last_year_eps)*companies.market_cap as diff_mcap 
                                      FROM earnings,
                                      companies ON companies.id = earnings.company_id
                                      WHERE earnings.company_id in (#{@companies.pluck(:id).join(",")})
                                      ORDER BY diff_mcap DESC")
    render "show"
  end

end
