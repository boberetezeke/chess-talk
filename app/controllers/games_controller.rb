class GamesController < InheritedResources::Base
  helper :application

  def edit
    super do
      #@game.actual_start_datetime = Time.now if @game.actual_start_datetime.nil?
    end
  end

  def update
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
