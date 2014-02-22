class RenameLinkToRedirect < ActiveRecord::Migration
  def change
    rename_column 'constructor_pages_pages', :link, :redirect
  end
end