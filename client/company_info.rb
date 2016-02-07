require 'selenium-webdriver'
require 'json'
require 'securerandom'
require "net/http"
require "uri"
require 'date'
require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3', # or 'postgresql' or 'sqlite3'
  database:  '../server/db/development.sqlite3'
  #host:     'localhost',
  #username: 'your_username',
  #password: 'your_password'
)

class Company < ActiveRecord::Base
end

class Company_info
  def initialize
    start
  end

  def start
    @companies = Company.all
    @companies.each do |company|
      uri = "https://www.google.com/finance?q=#{company.stock_symbol}"
      @driver = Selenium::WebDriver.for :firefox
      @driver.navigate.to uri
      begin
        element = @driver.find_element(:css => "#related .sfe-section .g-section .g-unit") # 0: Sector, 1: Industry
        elements = element.find_elements(:css => "a")
        sector = elements[0].text
        industry = elements[1].text
        puts "Sector: #{sector}, Industry: #{industry}"
        uri = URI.parse('http://server.dev/api/companies/'+company.id.to_s+'/classification')
        response = Net::HTTP.post_form(uri, {"sector": sector, "industry": industry})
      rescue => e
        puts "Couldn't find info for " + company.name
      end
      @driver.quit
    end
  end
end

Company_info.new

