class CreateStringTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::StringType.table_name do |t|
      t.string :value
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::StringType.table_name
  end
end
