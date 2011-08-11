class Game < ActiveRecord::Base
  belongs_to :scheduleable, :polymorphic => true
  has_many :game_roles, :dependent => :destroy
  has_many :users, :through => :game_roles
  has_many :comments, :dependent => :destroy
  
  after_save :update_standings

  class << self
    def unplayed
      where("actual_start_datetime is NULL").order("expected_start_date ASC")
    end

    def recent
      where("actual_start_datetime is NOT NULL").order("actual_start_datetime DESC").limit(10)
    end
  end

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
    result == "1-0"
  end

  def black_won
    result == "0-1"
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
    white_players = game_roles.select{|gr| gr.role == "white"}
    if white_players.empty?
      nil
    else
      white_players.first.user
    end
  end

  def white_player=(user)
    set_role(user, "white")
  end

  def black_player
    black_players = game_roles.select{|gr| gr.role == "black"}
    if black_players.empty?
      nil
    else
      black_players.first.user
    end
  end

  def black_player=(user)
    set_role(user, "black")
  end

  def winner
    return white_player if white_won
    return black_player if black_won
    return nil
  end

  def update_standings
    self.scheduleable.update_standings
  end

  private

  def set_role(user_id, color)
    if user_id.blank? then
      game_roles = self.game_roles.select{|gr| gr.role == color}
      return if game_roles.empty?
      game_role = game_roles.first
      game_role.role = ""
    else
      game_roles = self.game_roles.select{|gr| gr.user.id == user_id.to_i}
      return if game_roles.empty?
      game_role = game_roles.first
      game_role.role = color
    end
    game_role.save
  end
end
