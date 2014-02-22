class CreateFloatTypes < ActiveRecord::Migration
  def change
    create_table ConstructorPages::Types::FloatType.table_name do |t|
      t.float :value, default: 0.0
      t.references :field
      t.references :page

      t.timestamps
    end
  end
end
