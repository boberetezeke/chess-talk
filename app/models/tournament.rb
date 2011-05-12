class Tournament < ActiveRecord::Base
  has_many :tournament_games
end
