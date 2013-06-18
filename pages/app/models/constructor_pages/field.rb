# encoding: utf-8

module ConstructorPages
  # Field model. Fields allows to add custom fields for template.
  #
  # Each field has type of value such as float, integer, string...
  class Field < ActiveRecord::Base
    attr_accessible :name, :code_name, :type_value, :template_id, :template

    # Adding code_name_uniqueness method
    include CodeNameUniq

    # Array of available field types
    TYPES = %w{string integer float boolean text date html image}

    validates_presence_of :name
    validates_uniqueness_of :code_name, :scope => :template_id
    validate :code_name_uniqueness

    after_create :create_page_fields
    after_destroy :destroy_all_page_fields

    belongs_to :template

    # Adding has_many for all field types
    TYPES.each do |t|
      class_eval %{
        has_many :#{t}_types, class_name: 'Types::#{t.titleize}Type'
      }
    end

    has_many :pages, through: :template

    acts_as_list  scope: :template_id
    default_scope order: :position

    # Return constant of model type_value
    def type_class; "constructor_pages/types/#{type_value}_type".classify.constantize end

    # Return object of type_value by page
    def find_type_object(page); type_class.find_by_field_id_and_page_id(id, page.id) end

    # Create object of type_value by page
    def create_type_object(page); type_class.create(field_id: id, page_id: page.id) end

    # Remove all type_fields values for specified page
    def remove_type_object(page); find_type_object(page).destroy end

    # Get value from type_field for specified page
    def get_value_for(page)
      _type_object = find_type_object(page)
      _type_object ? _type_object.value : nil
    end

    # Set value type_field for specified page
    def set_value_for(page, value)
      _type_object = find_type_object(page)

      if _type_object
        _type_object.value = value
        _type_object.save!
      end
    end

    private

    # Check if there is code_name in template branch
    def check_code_name(code_name)
      [code_name.pluralize, code_name.singularize].each do |name|
        %w{self_and_ancestors descendants}.each do |m|
          if template.send(m).map{|t| t.code_name}.include?(name)
            return false
          end
        end
      end

      true
    end

    # Create and destroy page fields
    %w{create destroy_all}.each do |m|
      class_eval %{
          def #{m}_page_fields
            template.pages.each {|page| type_class.#{m} page_id: page.id, field_id: id}
          end
      }
    end
  end
end