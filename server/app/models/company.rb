class Company < ActiveRecord::Base
  has_many :earnings, dependent: :destroy
end
