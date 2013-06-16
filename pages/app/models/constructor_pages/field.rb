# encoding: utf-8

module ConstructorPages
  class Field < ActiveRecord::Base
    attr_accessible :name, :code_name, :type_value, :template_id, :template
    validates_presence_of :name
    validates_uniqueness_of :code_name, :scope => :template_id
    validate :method_uniqueness

    after_create :create_page_fields
    after_destroy :destroy_page_fields

    belongs_to :template

    has_one :string_type,   class_name: 'Types::StringType'
    has_one :integer_type,  class_name: 'Types::IntegerType'
    has_one :float_type,    class_name: 'Types::FloatType'
    has_one :boolean_type,  class_name: 'Types::BooleanType'
    has_one :text_type,     class_name: 'Types::TextType'
    has_one :date_type,     class_name: 'Types::DateType'
    has_one :html_type,     class_name: 'Types::HtmlType'
    has_one :image_type,    class_name: 'Types::ImageType'

    acts_as_list  scope: :template_id
    default_scope order: :position

    # return constant of model by type_value
    def type_model; "constructor_pages/types/#{type_value}_type".classify.constantize end

    # remove all type_fields values for specified page
    def remove_values_for(page); type_model.destroy_all field_id: id, page_id: page.id end

    def update_value(page, params)
      _type_value = type_model.where(field_id: id, page_id: page.id).first_or_create

      if params
        _type_value.value = 0 if type_value == 'boolean'

        if params[type_value]
          if type_value == 'date'
            value = params[type_value][id.to_s]
            _type_value.value = Date.new(value['date(1i)'].to_i, value['date(2i)'].to_i, value['date(3i)'].to_i).to_s
          else
            _type_value.value = params[type_value][id.to_s]
          end
        end

        _type_value.save
      end
    end

    private

    def method_uniqueness
      if Page.first.respond_to?(code_name) \
      or Page.first.respond_to?(code_name.pluralize) \
      or Page.first.respond_to?(code_name.singularize) \
      or template.self_and_ancestors.map{|t| t.code_name unless t.code_name == code_name}.include?(code_name.pluralize) \
      or template.self_and_ancestors.map{|t| t.code_name unless t.code_name == code_name}.include?(code_name.singularize) \
      or template.descendants.map{|t| t.code_name unless t.code_name == code_name}.include?(code_name.pluralize) \
      or template.descendants.map{|t| t.code_name unless t.code_name == code_name}.include?(code_name.singularize)
        errors.add(:base, 'Такой метод уже используется')
      end
    end

    def create_page_fields
      self.template.pages.each do |page|
        "constructor_pages/types/#{type_value}_type".classify.constantize.create page_id: page.id, field_id: id
      end
    end

    def destroy_page_fields
      self.template.pages.each do |page|
        "constructor_pages/types/#{type_value}_type".classify.constantize.destroy_all page_id: page.id, field_id: id
      end
    end
  end
end