class CreateIntegerTypes < ActiveRecord::Migration
  def change
    create_table ConstructorPages::Types::IntegerType.table_name do |t|
      t.integer :value, default: 0
      t.references :field
      t.references :page

      t.timestamps
    end
  end
end
