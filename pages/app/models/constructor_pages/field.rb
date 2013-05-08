# encoding: utf-8

module ConstructorPages
  class Field < ActiveRecord::Base
    attr_accessible :name, :code_name, :type_value, :template_id
    validates_presence_of :name

    after_create :create_page_field
    after_destroy :destroy_page_field

    belongs_to :template
    has_one :string_type
    has_one :number_type
    has_one :boolean_type

    private

    def create_page_field
      template.pages.each do |page|
        "constructor_pages/#{type_value}_type".classify.constantize.create(
          :page_id => page.id,
          :field_id => id
        )
      end
    end

    def destroy_page_field
      template.pages.each do |page|
        "constructor_pages/#{type_value}_type".classify.constantize.destroy_all(
            :page_id => page.id,
            :field_id => id
        )
      end
    end
  end
end