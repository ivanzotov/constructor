class CreateNumberTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::NumberType.table_name do |t|
      t.float :value
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::NumberType.table_name
  end
end
