module ConstructorPages
  # Field model. Fields allows to add custom fields for template.
  # Each field has type of value such as float, integer, string...
  class Field < ActiveRecord::Base
    # Array of available field types
    TYPES = %w{string integer float boolean text date html image file}

    TYPES.each {|t| class_eval %{has_many :#{t}_types, class_name: 'Types::#{t.titleize}Type'} }

    validates_presence_of :name
    validates_uniqueness_of :code_name, scope: :template_id
    validate :code_name_uniqueness

    after_create :create_page_fields
    after_destroy :destroy_all_page_fields
    after_save :update_template_view

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

    # Recreate template view
    def update_template_view
      self.template.drop_view
      self.template.create_view
    end

    # Check if code_name is not available
    def code_name_uniqueness
      errors.add(:base, :code_name_already_in_use) unless Page.check_code_name(code_name) and check_code_name(code_name)
    end

    # Check if there is code_name in template branch
    def check_code_name(code_name)
      [code_name.pluralize, code_name.singularize].each {|name|
        %w{self_and_ancestors descendants}.each {|m|
          return false if template.send(m).map(&:code_name).include?(name)}}
      true
    end

    def create_page_fields
      template.page_ids.each_slice(500) do |batch|
        _items = []
        batch.each do |_id|
          _items << type_class.new({page_id: _id, field_id: id})
        end
        type_class.import _items
      end
    end

    def destroy_all_page_fields
      template.page_ids.each_slice(1000) do |batch|
        type_class.where(page_id: batch, field_id: id).delete_all
        Page.update_all({updated_at: Time.now}, {id: batch})
      end
    end
  end
end