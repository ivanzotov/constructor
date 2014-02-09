class CreateTextTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Types::TextType.table_name do |t|
      t.text :value
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Types::TextType.table_name
  end
end
