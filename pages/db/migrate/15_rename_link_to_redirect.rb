class RenameLinkToRedirect < ActiveRecord::Migration
  def self.up
    rename_column 'constructor_pages_pages', :link, :redirect
  end

  def self.down
    rename_column 'constructor_pages_pages', :redirect, :link
  end
end