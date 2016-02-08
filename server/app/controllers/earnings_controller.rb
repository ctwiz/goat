class EarningsController < ApplicationController
  def index
    @earnings = Earning.order('reporting_date ASC')
  end

  def diff
    @earnings = Earning.find_by_sql('SELECT *, (eps_forecast - last_year_eps) as diff,
                                     (eps_forecast - last_year_eps)*companies.market_cap as diff_perc_nipps FROM earnings, companies on earnings.company_id = companies.id order by diff DESC')
    render "index"
  end

  def diff_mcap
    @earnings = Earning.find_by_sql('SELECT *, (eps_forecast - last_year_eps) as diff,
                                     (eps_forecast - last_year_eps)*companies.market_cap as diff_perc_nipps FROM earnings, companies on earnings.company_id = companies.id order by diff_perc_nipps DESC')
    render "index"
  end
end
