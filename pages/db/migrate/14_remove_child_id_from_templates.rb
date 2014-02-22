class RemoveChildIdFromTemplates < ActiveRecord::Migration
  def change
    remove_column 'constructor_pages_templates', :child_id, :boolean, default: true
  end
end