class CreateBadges < ActiveRecord::Migration
  def self.up
    create_table :badges do |t|
      t.references :user_id
      t.string :uuid
      t.string :label
      t.string :title
      t.string :url
      t.boolean :is_public
      t.timestamps
    end
  end

  def self.down
    drop_table :badges
  end
end
