class CreateDateTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Types::DateType.table_name do |t|
      t.date :value, :default => Time.now
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Types::DateType.table_name
  end
end
