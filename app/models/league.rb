class League < ActiveRecord::Base
  has_many :schedules
  has_many :tournaments
end
