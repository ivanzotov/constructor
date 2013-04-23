class CreateImages < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Image.table_name do |t|
      t.string :image_uid
      t.string  :image_name
      t.references :page     

      t.timestamps
    end
  end
  
  def self.down
    drop_table ConstructorPages::Image.table_name
  end
end
