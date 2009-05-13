class LinkMigration < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :url
      t.string :status
      t.string :file_path
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
