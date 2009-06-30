class AddDownloadingTimeToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :downloading_time, :string
    add_column :links, :download_speed, :string
  end

  def self.down
    remove_column :links, :downloading_time
    remove_column :links, :download_speed
  end
end