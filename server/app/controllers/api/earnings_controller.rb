class Api::EarningsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    @company = Company.find_by(name: params["company_name"])
    if @company.blank?
      # create company
      @company = Company.create(name: params["company_name"], stock_symbol: params["stock_symbol"], market_cap: params["market_cap"])
    else
      Company.update(@company.id, market_cap: params["market_cap"])
    end
    @earning = Earning.find_by(company_id: @company.id) #, reporting_date: date_format(params["reporting_date"]))
    if @earning.blank?
      @earning = Earning.create(company_id: @company.id,
                     reporting_date: date_format(params["reporting_date"]),
                     fiscal_quarter: params["fiscal_quarter"],
                     eps_forecast: params["eps_forecast"],
                     estimate_count: params["estimate_count"],
                     last_year_report_date: date_format(params[:last_year_report_date]),
                     last_year_eps: params[:last_year_eps]
                     )
    else
      Earning.update(@earning.id, 
        eps_forecast: params["eps_forecast"], 
        last_year_eps: params["last_year_eps"], 
        reporting_date: date_format(params["reporting_date"]),
        last_year_report_date: date_format(params["last_year_report_date"])
        )
    end
    render json: @earning
  end

  def date_format(d)
    puts "START DATE FORMAT"
    if /n\/a/.match(d)
    # 02/08/2016
      return 0
    else
      # comes in mm/dd/yyyy
      #02/11/2016
      Time.zone = 'Eastern Time (US & Canada)'
      puts "STOP DATE FORMAT"
      d = d.split("/")
      # need dd/mm/YYYY
      return Time.zone.parse("#{d[1]}/#{d[0]}/#{d[2]}")
    end
  end

end