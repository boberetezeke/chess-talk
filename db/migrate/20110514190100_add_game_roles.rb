class AddGameRoles < ActiveRecord::Migration
  def self.up
    create_table :game_role do |t|
      t.integer :game_id
      t.integer :user_id
      t.string :role
    end
  end

  def self.down
    drop_table :game_role
  end
end
