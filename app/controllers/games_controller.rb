class GamesController < ApplicationController
  def show
    show! do
      @page_title = @game.description
    end
  end
    
  def edit
    edit! do
      @page_title = "Edit #{@game.description}"
      #@game.actual_start_datetime = Time.now if @game.actual_start_datetime.nil?
    end
  end

  def update
    game = Game.find(params[:id])
    if !game.editable_by_user(current_user) then
      flash[:alert] = "You don't have permission to edit this game"
      redirect_to root_path
    else
      logger.debug "in update with date_time_set = #{datetime_set(:game, :actual_start_datetime).inspect}"
      if (!(params[:game][:white_player].blank?) || 
          !(params[:game][:black_player].blank?) ||
          !(params[:game][:result].blank?)       ||
          datetime_set(:game, :actual_start_datetime)) &&
         !(!(params[:game][:white_player].blank?) && 
           !(params[:game][:black_player].blank?) && 
           !(params[:game][:result].blank?) &&
           datetime_set(:game, :actual_start_datetime)) 

        flash[:alert] = "if any of the following are set, then all fields must be set: White, Black, Result, Date Played"
        redirect_to edit_game_path(params[:id])
      elsif !(params[:game][:white_player].blank?) && 
            !(params[:game][:black_player].blank?) &&
             (params[:game][:white_player] == params[:game][:black_player])
        flash[:alert] = "one player only for each color"
        redirect_to edit_game_path(params[:id])
      else
        super
      end
    end
  end

  private

  def datetime_set(object, root_param)
    all_set = true
    (1..5).each do |segment|
      if params[object]["#{root_param}(#{segment}i)"].blank?
        return false
      end
    end
    return true
  end
end
