class AddTemplateToPages < ActiveRecord::Migration
  def self.up
    change_table ConstructorPages::Page.table_name do |t|
      t.references :template
    end
  end

  def self.down
    change_table ConstructorPages::Page.table_name do |t|
      t.remove :template_id
    end
  end
end
