class AddLeagueToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :league_id, :integer
  end

  def self.down
    remove_column :users, :league_id
  end
end
