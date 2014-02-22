class CreateTemplates < ActiveRecord::Migration
  def change
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
end
