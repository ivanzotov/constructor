class CreateFloatTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Types::FloatType.table_name do |t|
      t.float :value, :default => 0.0
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Types::FloatType.table_name
  end
end
