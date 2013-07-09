# encoding: utf-8

module ConstructorPages
  # Field model. Fields allows to add custom fields for template.
  # Each field has type of value such as float, integer, string...
  class Field < ActiveRecord::Base
    # Adding code_name_uniqueness method
    include CodeNameUniq

    # Array of available field types
    TYPES = %w{string integer float boolean text date html image}.tap {|_t|
    _t.each {|t| class_eval %{has_many :#{t}_types, dependent: :destroy, class_name: 'Types::#{t.titleize}Type'}}}

    validates_presence_of :name
    validates_uniqueness_of :code_name, scope: :template_id
    validate :code_name_uniqueness

    after_create :create_page_fields
    after_destroy :destroy_all_page_fields

    has_many :pages, through: :template
    belongs_to :template

    acts_as_list scope: :template_id
    default_scope -> { order :position }

    # Return constant of model type_value
    def type_class; "constructor_pages/types/#{type_value}_type".classify.constantize end

    # Return object of type_value by page
    def find_type_object(page); type_class.find_by(field_id: id, page_id: page.id) end

    # Create object of type_value by page
    def create_type_object(page); type_class.create(field_id: id, page_id: page.id) end

    # Find or create type object by page
    def find_or_create_type_object(page); find_type_object(page) || create_type_object(page) end

    # Remove all type_fields values for specified page
    def remove_type_object(page); find_type_object(page).destroy end

    # Get value from type_field for specified page
    def get_value_for(page); find_type_object(page).tap {|t| return t && t.value} end

    # Set value type_field for specified page
    def set_value_for(page, value); find_type_object(page).tap {|t| t || return; t.update value: value} end

    private

    # Check if there is code_name in template branch
    def check_code_name(code_name)
      [code_name.pluralize, code_name.singularize].each {|name|
        %w{self_and_ancestors descendants}.each {|m|
          return false if template.send(m).map(&:code_name).include?(name)}}
      true
    end

    # Create and destroy page fields
    %w{create destroy_all}.each {|m| class_eval %{
      def #{m}_page_fields; template.pages.each {|page| type_class.#{m} page_id: page.id, field_id: id} end }}
  end
end