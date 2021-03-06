class UsersController < ApplicationController
  def dashboard
    @page_title = "Dashboard"
    @user = current_user
    if @user.league
      @schedule = @user.league.schedules.first
    else
      @schedule = League.first.schedules.first
    end
    @recent_games_played = Game.where('actual_start_datetime is not NULL').order('actual_start_datetime DESC').limit(10)
    @recent_comments = []
  end

  def show
    show! do
      @page_title = @user.name
    end
  end

  def create
    create! {redirect_to :dashboard}
  end
end
