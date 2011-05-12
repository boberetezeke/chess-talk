class AddInfoToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :expected_start_date, :date
    add_column :games, :actual_start_datetime, :datetime
    add_column :games, :round, :integer

    add_column :leagues, :round_length, :integer
    add_column :leagues, :round_length_unit, :string

    create_table :tournament_games do |t|
      t.integer :game_id
      t.integer :predecessor1_id
      t.integer :predecessor2_id
    end
  end

  def self.down
    remove_column :games, :expected_start_date
    remove_column :games, :actual_start_datetime
    remove_column :games, :round

    remove_column :leagues, :round_length
    remove_column :leagues, :round_length_unit

    drop_table :tournament_games
  end
end
