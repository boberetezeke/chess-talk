require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase

  context "simple league" do
    setup do
      @league = Factory(:league)
      @schedule = Factory(:schedule, :league => @league)
      @user1 = Factory(:user, :name => "user1")
      @user2 = Factory(:user, :name => "user2")
      @league.users << @user1
      @league.users << @user2
    end
=begin
    should "have all users have a 1600 rating with no games played" do
      @schedule.update_standings

      assert_equal User::DEFAULT_START_RATING, @user1.rating
      assert_equal User::DEFAULT_START_RATING, @user2.rating
      srs = @schedule.schedule_results
      assert_equal 2, srs.size
      assert_equal 0, srs.first.wins
      assert_equal 0, srs.first.losses
      assert_equal 0, srs.first.ties
      assert_equal 0, srs.second.wins
      assert_equal 0, srs.second.losses
      assert_equal 0, srs.second.ties
    end
=end
    should "change ratings and record based on one game" do
      @game = Factory(:game, :scheduleable => @schedule)
      @game_role1 = Factory(:game_role, :game => @game, :user => @user1, :role => "white")
      @game_role2 = Factory(:game_role, :game => @game, :user => @user2, :role => "black")
      @game.result = "1-0"
      @game.save

      @schedule.update_standings

      srs = @schedule.schedule_results.includes(:user).order("users.name")

      assert_equal 2, srs.size
      assert_equal 1, srs.first.wins
      assert_equal 0, srs.first.losses
      assert_equal 0, srs.first.ties
      assert_equal 0, srs.second.wins
      assert_equal 1, srs.second.losses
      assert_equal 0, srs.second.ties
      
      @user1.reload
      assert_equal 1628.8, @user1.rating
      @user2.reload
      assert_equal 1571.2, @user2.rating
    end
  end
end
