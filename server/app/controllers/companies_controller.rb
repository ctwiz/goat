class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
    @earnings = Earning.find_by_sql("SELECT *, (eps_forecast - last_year_eps) AS diff,
                                     (eps_forecast - last_year_eps)*companies.market_cap AS diff_mcap 
                                     FROM earnings,
                                     companies ON earnings.company_id = companies.id
                                     WHERE companies.id in (#{@company.id})
                                     ORDER BY reporting_date ASC")


  end
end
