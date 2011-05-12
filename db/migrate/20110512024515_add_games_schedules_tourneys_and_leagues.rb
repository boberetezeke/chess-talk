class AddGamesSchedulesTourneysAndLeagues < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :scheduleable_id
      t.string :scheduleable_type
      t.integer :white_player
      t.integer :black_player
      t.string :result
      t.text :game
    end

    create_table :schedules do |t|
      t.string :name
      t.integer :league_id
    end

    create_table :leagues do |t|
      t.string :name
    end

    create_table :tournaments do |t|
      t.integer :league_id
    end
  end

  def self.down
    drop_table :games
    drop_table :schedules
    drop_table :leagues
    drop_table :tournaments
  end
end
