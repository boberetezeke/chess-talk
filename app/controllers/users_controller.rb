class UsersController < InheritedResources::Base
  def dashboard
    @user = current_user
    @schedule = @user.league.schedules.first
    @recent_games_played = Game.where('actual_start_datetime is not NULL')
    @recent_comments = []
  end

  def create
    create! {redirect_to :dashboard}
  end
end
