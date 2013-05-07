class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Template.table_name do |t|
      t.string :name
      t.string :code_name
      t.integer :parent_id
      t.integer :child_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
  end
  
  def self.down
    drop_table ConstructorPages::Template.table_name
  end
end
