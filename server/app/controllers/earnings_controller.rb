class EarningsController < ApplicationController
  def index
    @earnings = Earnings.all
  end
end
