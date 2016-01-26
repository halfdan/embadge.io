class CreateBadges < ActiveRecord::Migration
  def self.up
    create_table :badges do |t|
      t.references :user
      t.string :label
      t.string :title
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :badges
  end
end
