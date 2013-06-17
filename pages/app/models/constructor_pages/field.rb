# encoding: utf-8

module ConstructorPages
  class Field < ActiveRecord::Base
    TYPES = %w{string integer float boolean text date html image}

    attr_accessible :name, :code_name, :type_value, :template_id, :template
    validates_presence_of :name
    validates_uniqueness_of :code_name, :scope => :template_id
    validate :method_uniqueness

    after_create :create_page_fields
    after_destroy :destroy_all_page_fields

    belongs_to :template

    TYPES.each do |t|
      class_eval %{
        has_many :#{t}_types, class_name: 'Types::#{t.titleize}Type'
      }
    end

    has_many :pages, through: :template

    acts_as_list  scope: :template_id
    default_scope order: :position

    # return constant of model by type_value
    def type_class; "constructor_pages/types/#{type_value}_type".classify.constantize end

    # return object of type_value
    def find_type_object(page); type_class.find_by_field_id_and_page_id(id, page.id) end

    # return created object of type_value
    def create_type_object(page); type_class.create(field_id: id, page_id: page.id) end

    def find_or_create_type_object(page); find_type_object(page) || create_type_object(page) end

    # get value from type_field for specified page
    def get_value_for(page)
      _type_object = find_type_object(page)
      _type_object ? _type_object.value : nil
    end

    # set value type_field for specified page
    def set_value_for(page, value)
      _type_object = find_type_object(page)

      if _type_object
        _type_object.value = value
        _type_object.save!
      end
    end

    # remove all type_fields values for specified page
    def remove_values_for(page); type_class.destroy_all field_id: id, page_id: page.id end

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

    %w{create destroy_all}.each do |m|
      class_eval %{
          def #{m}_page_fields
            template.pages.each {|page| type_class.#{m} page_id: page.id, field_id: id}
          end
      }
    end
  end
end