class RemoveContentFromPages < ActiveRecord::Migration
  def self.up
    remove_column ConstructorPages::Page.table_name, :content
  end

  def self.down
    change_table ConstructorPages::Page.table_name do |t|
      t.text :content, :default => ""
    end
  end
end
