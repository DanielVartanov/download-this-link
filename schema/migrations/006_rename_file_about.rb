class RenameFileAbout < ActiveRecord::Migration
  def self.up
    rename_column :links, :file_about, :description
  end

  def self.down
    rename_column :links, :description, :file_about
  end
end