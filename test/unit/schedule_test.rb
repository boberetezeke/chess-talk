require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase

  context "simple league" do
    setup do
      @league = Factory(:league)
      @schedule = Factory(:schedule, :league => @league)
      @user1 = Factory(:user, :name => "user1")
      @user2 = Factory(:user, :name => "user2")
      @user3 = Factory(:user, :name => "user3")
      @league.users << @user1
      @league.users << @user2
      @league.users << @user3
    end

=begin
    should "have all users have a 1600 rating with no games played" do
      @schedule.update_standings

      assert_equal User::DEFAULT_START_RATING, @user1.rating
      assert_equal User::DEFAULT_START_RATING, @user2.rating
      srs = @schedule.schedule_results
      assert_equal 3, srs.size
      assert_equal 0, srs.first.wins
      assert_equal 0, srs.first.losses
      assert_equal 0, srs.first.ties
      assert_equal 0, srs.second.wins
      assert_equal 0, srs.second.losses
      assert_equal 0, srs.second.ties
      assert_equal 0, srs.third.wins
      assert_equal 0, srs.third.losses
      assert_equal 0, srs.third.ties
    end

    should "change ratings and record based on one game" do
      @game = Factory(:game, :scheduleable => @schedule)
      @game_role1 = Factory(:game_role, :game => @game, :user => @user1, :role => "white")
      @game_role2 = Factory(:game_role, :game => @game, :user => @user2, :role => "black")
      @game.result = "1-0"
      @game.save

      @schedule.update_standings

      srs = @schedule.schedule_results.includes(:user).order("users.name")

      assert_equal 3, srs.size
      assert_equal 1, srs.first.wins
      assert_equal 0, srs.first.losses
      assert_equal 0, srs.first.ties
      assert_equal 0, srs.second.wins
      assert_equal 1, srs.second.losses
      assert_equal 0, srs.second.ties
      assert_equal 0, srs.third.wins
      assert_equal 0, srs.third.losses
      assert_equal 0, srs.third.ties
      
      @user1.reload
      assert_equal Stats.calc_rating(1600.0, 1600.0, Stats::WIN), @user1.rating 
      @user2.reload
      assert_equal Stats.calc_rating(1600.0, 1600.0, Stats::LOSS), @user2.rating
      @user3.reload
      assert_equal 1600.0, @user3.rating
    end

    should "change ratings and record based on one game but ignore unplayed game" do
      @game = Factory(:game, :scheduleable => @schedule)
      @game_role1 = Factory(:game_role, :game => @game, :user => @user1, :role => "white")
      @game_role2 = Factory(:game_role, :game => @game, :user => @user2, :role => "black")
      @game.result = "1-0"
      @game.save

      @game = Factory(:game, :scheduleable => @schedule)
      @game_role1 = Factory(:game_role, :game => @game, :user => @user1)
      @game_role2 = Factory(:game_role, :game => @game, :user => @user2)

      @schedule.update_standings

      srs = @schedule.schedule_results.includes(:user).order("users.name")

      assert_equal 3, srs.size
      assert_equal 1, srs.first.wins
      assert_equal 0, srs.first.losses
      assert_equal 0, srs.first.ties
      assert_equal 0, srs.second.wins
      assert_equal 1, srs.second.losses
      assert_equal 0, srs.second.ties
      assert_equal 0, srs.third.wins
      assert_equal 0, srs.third.losses
      assert_equal 0, srs.third.ties
      
      @user1.reload
      assert_equal Stats.calc_rating(1600.0, 1600.0, Stats::WIN), @user1.rating 
      @user2.reload
      assert_equal Stats.calc_rating(1600.0, 1600.0, Stats::LOSS), @user2.rating
      @user3.reload
      assert_equal 1600.0, @user3.rating
    end

    should "change ratings and record based on two games" do
      @game = Factory(:game, :scheduleable => @schedule)
      @game_role1 = Factory(:game_role, :game => @game, :user => @user1, :role => "white")
      @game_role2 = Factory(:game_role, :game => @game, :user => @user2, :role => "black")
      @game.result = "1-0"
      @game.actual_start_datetime = Time.now
      @game.save

      @game2 = Factory(:game, :scheduleable => @schedule)
      @game2_role1 = Factory(:game_role, :game => @game2, :user => @user1, :role => "white")
      @game2_role2 = Factory(:game_role, :game => @game2, :user => @user3, :role => "black")
      @game2.result = "0.5-0.5"
      @game2.actual_start_datetime = Time.now + 1
      @game2.save

      @schedule.update_standings

      srs = @schedule.schedule_results.includes(:user).order("users.name")

      assert_equal 3, srs.size
      assert_equal "user1", srs.first.user.name
      assert_equal 1, srs.first.wins
      assert_equal 0, srs.first.losses
      assert_equal 1, srs.first.ties
      assert_equal 0, srs.second.wins
      assert_equal 1, srs.second.losses
      assert_equal 0, srs.second.ties
      assert_equal 0, srs.third.wins
      assert_equal 0, srs.third.losses
      assert_equal 1, srs.third.ties
      
      @user1.reload
      assert_equal( 
        Stats.calc_rating(
          Stats.calc_rating(1600.0, 1600.0, Stats::WIN),
          1600.0, 
          Stats::TIE).floor, @user1.rating.floor) 
      @user2.reload
      assert_equal Stats.calc_rating(1600.0, 1600.0, Stats::LOSS), @user2.rating
      @user3.reload
      assert_equal(
        Stats.calc_rating(
          1600.0,
          Stats.calc_rating(1600.0, 1600.0, Stats::WIN),
          Stats::TIE).floor, @user3.rating.floor)
    end
=end

    should "change ratings and record based on four games" do
      # Game 2: user1 def user3
      @game = Factory(:game, :scheduleable => @schedule)
      @game_role1 = Factory(:game_role, :game => @game, :user => @user1, :role => "white")
      @game_role2 = Factory(:game_role, :game => @game, :user => @user3, :role => "black")
      @game.result = "1-0"
      @game.actual_start_datetime = Time.now + 2
      @game.save

      # Game 0: user1 def user2
      @game = Factory(:game, :scheduleable => @schedule)
      @game_role1 = Factory(:game_role, :game => @game, :user => @user1, :role => "white")
      @game_role2 = Factory(:game_role, :game => @game, :user => @user2, :role => "black")
      @game.result = "1-0"
      @game.actual_start_datetime = Time.now
      @game.save

      # Game 3: user2 def user3
      @game = Factory(:game, :scheduleable => @schedule)
      @game_role1 = Factory(:game_role, :game => @game, :user => @user2, :role => "white")
      @game_role2 = Factory(:game_role, :game => @game, :user => @user3, :role => "black")
      @game.result = "1-0"
      @game.actual_start_datetime = Time.now + 3
      @game.save

      # Game 1: user1 tie user3
      @game2 = Factory(:game, :scheduleable => @schedule)
      @game2_role1 = Factory(:game_role, :game => @game2, :user => @user1, :role => "white")
      @game2_role2 = Factory(:game_role, :game => @game2, :user => @user3, :role => "black")
      @game2.result = "0.5-0.5"
      @game2.actual_start_datetime = Time.now + 1
      @game2.save

      @schedule.update_standings

      srs = @schedule.schedule_results.includes(:user).order("users.name")

      assert_equal 3, srs.size
      assert_equal "user1", srs.first.user.name
      assert_equal 2, srs.first.wins
      assert_equal 0, srs.first.losses
      assert_equal 1, srs.first.ties
      assert_equal "user2", srs.second.user.name
      assert_equal 1, srs.second.wins
      assert_equal 1, srs.second.losses
      assert_equal 0, srs.second.ties
      assert_equal "user3", srs.third.user.name
      assert_equal 0, srs.third.wins
      assert_equal 2, srs.third.losses
      assert_equal 1, srs.third.ties
      
      # user1 def user2
      @user1_after_game1 = Stats.calc_rating(1600.0, 1600.0, Stats::WIN)
      @user2_after_game1 = Stats.calc_rating(1600.0, 1600.0, Stats::LOSS)

      # user1 tie user3
      @user1_after_game2 = Stats.calc_rating(@user1_after_game1, 1600.0, Stats::TIE)
      @user3_after_game2 = Stats.calc_rating(1600.0, @user1_after_game1, Stats::TIE)

      # user1 def user3
      @user1_after_game3 = Stats.calc_rating(@user1_after_game2, @user3_after_game2, Stats::WIN)
      @user3_after_game3 = Stats.calc_rating(@user3_after_game2, @user1_after_game2, Stats::LOSS)

      # user2 def user3
      @user2_after_game4 = Stats.calc_rating(@user2_after_game1, @user3_after_game3, Stats::WIN)
      @user3_after_game4 = Stats.calc_rating(@user3_after_game3, @user2_after_game1, Stats::LOSS)


      @user1.reload
      @user2.reload
      @user3.reload

      assert_equal(@user1_after_game3.floor, @user1.rating.floor)
      assert_equal(@user2_after_game4.floor, @user2.rating.floor)
      assert_equal(@user3_after_game4.floor, @user3.rating.floor)
    end
  end
end
