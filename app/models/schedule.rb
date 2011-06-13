require "chess_ratings_calculator.rb"

class Schedule < ActiveRecord::Base
  has_many :games, :as => :scheduleable, :dependent => :destroy
  has_many :schedule_results
  belongs_to :league

  def update_standings
    ChessRatingsCalculator.new(self).calculate
  end
end
