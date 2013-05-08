class AddPositionToFields < ActiveRecord::Migration
  def self.up
    change_table ConstructorPages::Field.table_name do |t|
      t.integer :position
    end
  end

  def self.down
    remove_column ConstructorPages::Field.table_name, :position
  end
end
