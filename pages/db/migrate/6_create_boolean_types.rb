class CreateBooleanTypes < ActiveRecord::Migration
  def change
    create_table ConstructorPages::Types::BooleanType.table_name do |t|
      t.boolean :value, default: false
      t.references :field
      t.references :page

      t.timestamps
    end
  end
end
