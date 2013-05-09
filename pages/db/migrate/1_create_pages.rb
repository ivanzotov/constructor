class CreatePages < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Page.table_name do |t|
      t.boolean :active, :default => true
      t.string  :name,  :default => ""
      t.boolean :auto_url, :default => true
      t.string  :full_url, :default => ""
      t.string  :url,    :default => ""
      t.string  :link,   :default => ""
      t.string  :title, :default => ""
      t.string  :keywords, :default => ""
      t.text    :description, :default => ""
      t.boolean :in_menu, :default => true
      t.boolean :in_nav,  :default => true
      t.boolean :in_map,  :default => true
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.references :template
      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Page.table_name
  end
end
