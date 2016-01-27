class CreateBadgeChanges < ActiveRecord::Migration
  def self.up
    create_table :badge_changes do |t|
      t.references :badge
      t.references :user
      t.string :version_start
      t.string :version_end
      t.string :version_range
      t.string :status, default: 'proposed'
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :badge_changes
  end
end
