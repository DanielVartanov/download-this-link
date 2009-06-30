class AddFileSizeToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :file_size, :integer
  end

  def self.down
    remove_column :links, :file_size
  end
end