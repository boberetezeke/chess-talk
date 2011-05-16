class AddInfoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :record, :string
    add_column :users, :rating, :float
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :record
    remove_column :users, :rating
  end
end
