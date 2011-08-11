class UsersController < InheritedResources::Base
  helper ApplicationHelper
  def dashboard
    @user = current_user
    @schedule = @user.league.schedules.first
    @recent_games_played = Game.where('actual_start_datetime is not NULL').order('actual_start_datetime DESC').limit(10)
    @recent_comments = []
  end

  def create
    create! {redirect_to :dashboard}
  end
end
