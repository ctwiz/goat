class Earning < ActiveRecord::Base
  belongs_to :company
  

  def up?
    if self.last_year_eps.to_i < self.eps_forecast.to_i
      return true
    else
      return false
    end
  end

  def nochange?
    if self.last_year_eps.to_i == self.eps_forecast.to_i
      return true
    else
      return false
    end
  end

  def down?
    if self.last_year_eps.to_i > self.eps_forecast.to_i
      return true
    else
      return false
    end
  end
end
