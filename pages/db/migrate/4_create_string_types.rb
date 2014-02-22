class CreateStringTypes < ActiveRecord::Migration
  def change
    create_table ConstructorPages::Types::StringType.table_name do |t|
      t.string :value, default: ''
      t.references :field
      t.references :page

      t.timestamps
    end
  end
end
