class RemoveSeoFromPages < ActiveRecord::Migration
  def self.up
    remove_column ConstructorPages::Page.table_name, :seo_title
    remove_column ConstructorPages::Page.table_name, :keywords
    remove_column ConstructorPages::Page.table_name, :description
  end

  def self.down
    change_table ConstructorPages::Page.table_name do |t|
      t.string  :seo_title, :default => ""
      t.string  :keywords, :default => ""
      t.text    :description, :default => ""
    end
  end
end