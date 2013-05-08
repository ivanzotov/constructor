class CreateAddressTypes < ActiveRecord::Migration
  def self.up
    create_table ConstructorPages::Types::AddressType.table_name do |t|
      t.string :value, :default => ""
      t.string :full_url, :default => ""
      t.boolean :auto_url, :default => true

      t.references :field
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table ConstructorPages::Types::AddressType.table_name
  end
end
