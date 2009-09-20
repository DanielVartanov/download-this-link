class AddCaptchaToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :captcha_value, :string
  end

  def self.down
    remove_column :links, :captcha_value
  end
end