class Api::EarningsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    @company = Company.find_by(stock_symbol: params["stock_symbol"])
    if @company.blank?
      # create company
      @company = Company.create(name: params["company_name"], stock_symbol: params["stock_symbol"], market_cap: cap_format(params["market_cap"]))
    end
    @earning = Earning.find_by(company_id: @company.id, reporting_date: date_format(params["reporting_date"]))
    if @earning.blank?
      @earning = Earning.create(company_id: @company.id,
                     reporting_date: date_format(params["reporting_date"]),
                     fiscal_quarter: params["fiscal_quarter"],
                     eps_forecast: eps_format(params["eps_forecast"]),
                     estimate_count: params["estimate_count"],
                     last_year_report_date: params[:last_year_report_date],
                     last_year_eps: eps_format(params[:last_year_eps])
                     )
    end
    render json: @earning
  end

  def cap_format(cap)
    unless cap.match("n/a").blank?
      return 0
    end

    cap = cap.tr('$', '')

    if cap.match("B").blank?
      multiple = 1000000000
      (cap*multiple).to_i
    end

    if cap.match("M").blank?
      multiple = 1000000
      (cap*multiple).to_i
    end

    return cap
  end

  def date_format(d)
    unless d.match("n/a").blank?
    # 02/08/2016
      return 0
    else
      d = d.split("/").map {|m| m.to_i}
      return DateTime.new(d[2], d[0], d[1])
    end
  end

  def eps_format(eps)
    unless eps.match("n/a").blank?
      eps = 0
    else
      eps = eps.tr('$', '')
      eps = (eps.to_f*100).to_i
    end
  end
end