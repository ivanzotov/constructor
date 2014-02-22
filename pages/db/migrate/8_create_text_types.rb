class CreateTextTypes < ActiveRecord::Migration
  def change
    create_table ConstructorPages::Types::TextType.table_name do |t|
      t.text :value
      t.references :field
      t.references :page

      t.timestamps
    end
  end
end
