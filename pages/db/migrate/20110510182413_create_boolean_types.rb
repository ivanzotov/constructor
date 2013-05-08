class CreateBooleanTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::BooleanType.table_name do |t|
      t.boolean :value, :default => false
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::BooleanType.table_name
  end
end
