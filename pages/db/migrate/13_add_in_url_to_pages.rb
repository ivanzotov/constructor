class AddInUrlToPages < ActiveRecord::Migration
  def self.up
    add_column 'constructor_pages_pages', :in_url, :boolean, default: true

    ConstructorPages::Page.reset_column_information

    ConstructorPages::Page.all.each do |p|
      p.in_url = true
      p.save
    end

  end

  def self.down
    remove_column 'constructor_pages_pages', :in_url
  end
end
