class AddComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.integer :game_id
      t.string  :move
      t.text    :text
    end
  end

  def self.down
    drop_table :comments
  end
end
