class FixGamesTable < ActiveRecord::Migration
  def self.up
    remove_column :games, :scheduleable_id
    add_column :games, :scheduleable_id, :integer
    remove_column :games, :white_player
    remove_column :games, :black_player
  end

  def self.down
    remove_column :games, :scheduleable_id
    add_column :games, :scheduleable_id, :string
    add_column :games, :white_player, :integer
    add_column :games, :black_player, :integer
  end
end
