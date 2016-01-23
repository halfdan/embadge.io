class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.integer :github_id
      t.integer :github_handle
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
