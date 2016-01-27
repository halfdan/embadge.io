class CreateBadges < ActiveRecord::Migration
  def self.up
    create_table :badges do |t|
      t.references :user
      t.string :label
      t.string :title
      t.string :url
      t.string :version_start
      t.string :version_end
      t.string :version_range
      t.timestamps
    end
  end

  def self.down
    drop_table :badges
  end
end
