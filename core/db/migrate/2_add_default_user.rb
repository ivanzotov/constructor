class AddDefaultUser < ActiveRecord::Migration
  def self.up
    ConstructorCore::User.create!(:email => "ivanzotov@gmail.com", :password => "123qweASD")
  end

  def self.down
    ConstructorCore::User.delete_all
  end
end
