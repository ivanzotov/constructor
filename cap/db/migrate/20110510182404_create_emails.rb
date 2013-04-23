class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table ConstructorCap::Email.table_name do |t|
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorCap::Email.table_name
  end
end
