class AddFileAboutToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :file_about, :string
  end

  def self.down
    remove_column :links, :file_about
  end
end