# encoding: utf-8

module ConstructorPages
  class Page < ActiveRecord::Base
    attr_accessible :parent_id, :link, :in_menu, :in_map,
                    :in_nav, :template_id

    has_many :string_types,:dependent => :destroy, :class_name => "Types::StringType"
    has_many :float_types, :dependent => :destroy, :class_name => "Types::FloatType"
    has_many :boolean_types, :dependent => :destroy, :class_name => "Types::BooleanType"
    has_many :integer_types, :dependent => :destroy, :class_name => "Types::IntegerType"
    has_many :text_types, :dependent => :destroy, :class_name => "Types::TextType"
    has_many :date_types, :dependent => :destroy, :class_name => "Types::DateType"
    has_many :html_types, :dependent => :destroy, :class_name => "Types::HtmlType"
    has_many :image_types, :dependent => :destroy, :class_name => "Types::ImageType"
    has_many :address_types, :dependent => :destroy, :class_name => "Types::AddressType"

    belongs_to :template

    default_scope order(:lft)

    after_create :create_fields
    
    acts_as_nested_set
    
    def self.children_of(page)
      Page.where(:parent_id => page)
    end

    def field(code_name)
      field = ConstructorPages::Field.where(:code_name => code_name, :template_id => self.template_id).first

      if field
        f = "constructor_pages/types/#{field.type_value}_type".classify.constantize.where(:field_id => field.id, :page_id => self.id).first
        f ? f.value : ""
      end
    end

    def method_missing(name, *args, &block)
      field(name)
    end

    private

    def create_fields
      template.fields.each do |field|
        "constructor_pages/types/#{field.type_value}_type".classify.constantize.create(
            :page_id => id,
            :field_id => field.id)
      end
    end
  end
end