class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :user
      t.references :badge_change
      t.text :comment
      t.timestamps
    end

    add_index :votes, [:user_id, :badge_change_id], unique: true
  end

  def self.down
    drop_table :votes
  end
end
