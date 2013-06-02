class CreateTextTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Types::TextType.table_name do |t|
      t.text :value, :default => "", :limit => 4294967295
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Types::TextType.table_name
  end
end
