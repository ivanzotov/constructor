class AddIndexes < ActiveRecord::Migration
  def change
    add_index ConstructorPages::Page.table_name, :parent_id
    add_index ConstructorPages::Page.table_name, :lft
    add_index ConstructorPages::Page.table_name, :rgt

    add_index ConstructorPages::Template.table_name, :parent_id
    add_index ConstructorPages::Template.table_name, :lft
    add_index ConstructorPages::Template.table_name, :rgt

    add_index ConstructorPages::Field.table_name, :type_value
  end
end