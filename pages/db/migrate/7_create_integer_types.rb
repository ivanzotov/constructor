class CreateIntegerTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Types::IntegerType.table_name do |t|
      t.integer :value, :default => 0
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Types::IntegerType.table_name
  end
end
