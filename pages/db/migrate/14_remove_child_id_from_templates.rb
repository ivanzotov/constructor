class RemoveChildIdFromTemplates < ActiveRecord::Migration
  def self.up
    remove_column 'constructor_pages_templates', :child_id
  end

  def self.down
    add_column 'constructor_pages_templates', :child_id, :boolean, default: true
  end
end