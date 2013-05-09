class CreateImageTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Types::ImageType.table_name do |t|
      t.string :value_uid
      t.string  :value_name
      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Types::ImageType.table_name
  end
end
