class DeviseUsers < ActiveRecord::Migration
  def self.up
    create_table ConstructorCore::User.table_name do |t|
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.string :authentication_token
    end

    add_index ConstructorCore::User.table_name, :email,                :unique => true
    add_index ConstructorCore::User.table_name, :reset_password_token, :unique => true
  end

  def self.down
    drop_table ConstructorCore::User.table_name
  end
end
