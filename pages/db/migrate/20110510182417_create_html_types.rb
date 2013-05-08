class CreateHtmlTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Types::HtmlType.table_name do |t|
      t.text :value, :default => ""
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Types::HtmlType.table_name
  end
end
