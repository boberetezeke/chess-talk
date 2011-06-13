class AddWinsLossesTiesToUsers < ActiveRecord::Migration
  def self.up
    create_table :schedule_results do |t|
      t.integer :schedule_id
      t.integer :user_id
      t.integer :wins
      t.integer :losses
      t.integer :ties
      t.integer :order
    end

    remove_column :users, :record
  end

  def self.down
    drop_table :schedule_results
    add_column :users, :record, :string
  end
end
