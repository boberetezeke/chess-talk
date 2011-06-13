class AddRatingCaching < ActiveRecord::Migration
  def self.up
    add_column :game_roles, :rating_before, :float
    add_column :game_roles, :rating_after, :float
  end

  def self.down
    remove_column :game_roles, :rating_before
    remove_column :game_roles, :rating_after
  end
end
