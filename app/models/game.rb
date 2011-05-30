class Game < ActiveRecord::Base
  belongs_to :scheduleable, :polymorphic => true
  has_many :game_roles, :dependent => :destroy
  has_many :users, :through => :game_roles
  has_many :comments, :dependent => :destroy

  def opponent(user)
    raise "more than two players for this game" unless game_roles.size == 2
    opponents = game_roles.inject([]) {|sum,gr| gr.user != user ? (sum + [gr]) : sum }
    if opponents.size == 0 then
      raise "user both players in the game"
    elsif opponents.size == 1
        return opponents.first
    else
      raise "user is not a player in this game"
    end
  end

  def white_won
    result == "1-0" || result == "0.5-0.5"
  end

  def black_won
    result == "0-1" || result == "0.5-0.5"
  end

  def result_for_user(user)
    if result == "1-0" then
      (user == white_player) ? "Win" : "Loss"
    elsif result == "0-1" then
      (user == black_player) ? "Win" : "Loss"
    elsif result == "0.5-0.5" then
      "Tie"
    else
      ""
    end
  end

  def white_player
    game_roles.select{|gr| gr.role == "white"}.first.user
  end

  def black_player
    game_roles.select{|gr| gr.role == "black"}.first.user
  end
end
