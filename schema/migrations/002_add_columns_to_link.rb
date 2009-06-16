class AddColumnsToLink < ActiveRecord::Migration
  def self.up
    add_column :links, :error_message, :string
    add_column :links, :complete_percentage, :string
  end

  def self.down
    remove_column :links, :error_message
    remove_column :links, :complete_percentage
  end
end

