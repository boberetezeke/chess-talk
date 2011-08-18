class AddByeColumn < ActiveRecord::Migration
  def self.up
    add_column "games", "bye", :boolean, :default => false
  end

  def self.down
    remove_column "games", "bye"
  end
end
