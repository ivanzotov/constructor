class AddDefaultTemplate < ActiveRecord::Migration
  def self.up
    ConstructorPages::Template.create!(
      name: 'Page',
      code_name: 'page',
      child_id: 1
    )
  end

  def self.down
    ConstructorPages::Template.delete_all
  end
end
