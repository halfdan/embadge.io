class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :user
      t.references :badge_info
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
