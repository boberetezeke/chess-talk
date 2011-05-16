class MoreGameFixing < ActiveRecord::Migration
  def self.up
    rename_table :game_role, :game_roles
    rename_column :games, :game, :pgn
  end

  def self.down
    rename_table :game_roles, :game_role
    rename_column :games, :pgn, :game
  end
end
