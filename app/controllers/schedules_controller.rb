class SchedulesController < ApplicationController
  helper ApplicationHelper

  def show
    show! do
      @page_title = "#{@schedule.league.name} - #{@schedule.name}"
      @rounds = {}
      @schedule.games.each do |game|
        @rounds[game.round] ||= []
        @rounds[game.round] += [game]
      end
    end
  end
end
