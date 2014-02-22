class CreateDateTypes < ActiveRecord::Migration
  def change
    create_table ConstructorPages::Types::DateType.table_name do |t|
      t.date :value, default: Time.now
      t.references :field
      t.references :page

      t.timestamps
    end
  end
end
