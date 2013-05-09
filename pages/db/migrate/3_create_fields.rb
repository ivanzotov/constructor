class CreateFields < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Field.table_name do |t|
      t.string :name
      t.string :code_name
      t.string :type_value
      t.integer :position
      t.references :template

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Field.table_name
  end
end
