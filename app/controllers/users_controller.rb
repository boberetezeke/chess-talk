class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @schedule = @user.league.schedules.first
    @recent_games_played = Game.where('actual_start_datetime is not NULL')
    @recent_comments = []
  end
end
