class League < ActiveRecord::Base
  has_many :schedules, :dependent => :destroy
  has_many :tournaments, :dependent => :destroy
  has_many :users
end
