class AddCaptchaValToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :captcha_val, :string
  end

  def self.down
    remove_column :links, :captcha_val
  end
end