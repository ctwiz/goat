require 'selenium-webdriver'
require 'json'
require 'securerandom'
require "net/http"
require "uri"
require 'date'


class Earnings_calendar
  def initialize
    start
  end

  def format_data(tr)
    tds = tr.find_elements(:css => "td")
    # Time, Company_name (Symbol) & Market Cap, Reported Date, Fiscal Quarter Ending, Consensus EPS forecast, # of Ests, EPS, %Surprise (difference from estimate)
    td0 = tds[0]
    time_of_day = td0.text()

    # Company name, Symbol, and Market Cap
    td1 = tds[1]
    #match_data = '###' #/<.*">(.*) \((.*)\) .*Market Cap\: (\$.*)<\/b>/.match(td1.text())
    match_data = /(.*) \((.*)\)\nMarket Cap: (.*)/.match(td1.text())
    company_name = match_data[1]
    symbol = match_data[2]
    market_cap = match_data[3]

    td2 = tds[2]
    expected_reported_date = td2.text()
    td3 = tds[3]
    fiscal_quarter_ending = td3.text()
    td4 = tds[4]
    eps_forecast = td4.text()
    td5 = tds[5]
    estimate_count = td5.text()
    td6 = tds[6]
    last_year_report_date = td6.text()
    td7 = tds[7]
    last_year_eps = td7.text()
    m = {
     "company_name" => company_name,
     "stock_symbol" => symbol,
     "market_cap" => cap_format(market_cap),
     "reporting_date" => expected_reported_date,
     "fiscal_quarter" => fiscal_quarter_ending,
     "eps_forecast" => eps_format(eps_forecast),
     "estimate_count" => estimate_count,
     "last_year_report_date" => last_year_report_date,
     "last_year_eps" => eps_format(last_year_eps)
      }
    puts "Sending #{m}"
    return m
  end

  def cap_format(cap)
    puts "START CAP FORMAT"
    begin
      puts "START TR"
      cap = cap.tr('$', '')
      puts "STOP TR"
      puts "START MATCH"
      if /B/.match(cap)
        cap = cap.tr('B', '')
        puts "inside B"
        puts "Cap after tr: #{cap}"
        multiple = 1000000000
        cap = cap.to_f*multiple
        puts "Cap after multiple: #{cap}"
      elsif /M/.match(cap)
        cap = cap.tr('M', '')
        puts "inside B"
        puts "Cap after tr: #{cap}"
        multiple = 1000000
        cap = cap.to_f*multiple
        puts "Cap after multiple: #{cap}"
      else
        cap = 0
      end
      cap = cap.to_i
      puts "STOP CAP FORMAT: #{cap}"
      return cap
    rescue => e
      puts e
      puts cap
      exit
    end
  end


  def eps_format(eps)
    puts "START EPS FORMAT: #{eps}"
    if /n\/a/.match(eps)
      puts "No EPS"
      eps = 0
    else
      eps = eps.tr('$', '')
      puts "EPS AFTER TR: #{eps}"
      eps = (eps.to_f*100).to_i
      puts "EPS AFTER CONVERT: #{eps}"
    end
    puts "STOP EPS FORMAT"
    return eps
  end

  def start
    years = [2016]
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Nov", "Dec"]
    dims = {"JanMarMayJulAugOctDec" => 31, "AprJunSepNov" => 30, "Feb" => 28}
    holidays = ["2016-01-01", "2016-01-18", "2016-02-15", "2016-03-25", "2016-05-30", "2016-07-04", "2016-09-05", "2016-11-24", "2016-12-26"]
    years.each do |year|
      months.each do |month|
        dim = (dims.keys.grep /#{month}/)
        dim = dims[dim[0]]
        if month == "Feb" && DateTime.new(year).leap?
          dim = 29
        end
        days = (01..dim)
        ## http://www.nasdaq.com/earnings/earnings-calendar.aspx?date=2016-Feb-05
        n_month = Date::ABBR_MONTHNAMES.index(month)
        days.each do |day|
          day = "%02d" % day
          r_day = DateTime.new(year.to_i, n_month.to_i, day.to_i)
          n_month = "%02d" % n_month
          unless r_day.saturday? || r_day.sunday? || holidays.include?(year.to_s+"-"+n_month.to_s+"-"+day.to_s) || r_day < DateTime.now
            uri_date = "#{year}-#{month}-#{day}"
            uri = "http://www.nasdaq.com/earnings/earnings-calendar.aspx?date="+uri_date
            puts "On #{uri}"
            @driver = Selenium::WebDriver.for :firefox
            @driver.navigate.to uri
            elements = @driver.find_elements(:css => "table#ECCompaniesTable tbody tr")
            if elements.count == 0
              next
            else
              elements.each do |tr|
                m = format_data(tr)
                uri = URI.parse('http://server.dev/api/earnings/create')
                response = Net::HTTP.post_form(uri, m)
                puts "#{m["company_name"]} added."
              end
            end
            @driver.quit
          end
        end
      end
    end
  end
end

Earnings_calendar.new