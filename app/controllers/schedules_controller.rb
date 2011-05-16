class SchedulesController < ApplicationController
  def show
    show! do
      @rounds = {}
      @schedule.games.each do |game|
        @rounds[game.round] ||= []
        @rounds[game.round] += [game]
      end
    end
  end
end
