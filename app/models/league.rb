class League < ActiveRecord::Base
  has_many :schedules
  has_many :tournaments
  has_many :users
end
