class EarningsController < ApplicationController
  def index
    @earnings = Earning.all
  end
end
