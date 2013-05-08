class RemoveFieldsFromPages < ActiveRecord::Migration
  def self.up
    remove_column ConstructorPages::Page.table_name, :title
    remove_column ConstructorPages::Page.table_name, :address
    remove_column ConstructorPages::Page.table_name, :url
    remove_column ConstructorPages::Page.table_name, :full_url
  end

  def self.down
    change_table ConstructorPages::Page.table_name do |t|
      t.boolean :active, :default => true
      t.string  :title,  :default => ""
      t.boolean :auto_url, :default => true
      t.string  :full_url, :default => ""
      t.string  :url,    :default => ""
    end
  end
end
