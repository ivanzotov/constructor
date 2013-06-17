# encoding: utf-8

module ConstructorPages
  class Page < ActiveRecord::Base
    attr_accessible :name, :title, :keywords, :description,
                    :url, :full_url, :active, :auto_url,
                    :parent, :parent_id, :link, :in_menu, :in_map,
                    :in_nav, :template_id, :template

    Field::TYPES.each do |t|
      class_eval %{
        has_many :#{t}_types,  dependent: :destroy, class_name: 'Types::#{t.titleize}Type'
      }
    end

    has_many :fields, through: :template

    belongs_to :template

    default_scope order :lft

    validate :template_check

    before_save :friendly_url, :template_assign, :full_url_update
    after_update :descendants_update
    after_create :create_fields

    acts_as_nested_set

    def self.find_by_request_or_first(request)
      request.nil? ? Page.first : Page.find_by_full_url('/' + request)
    end

    # generate full_url from parent page and url
    def self.full_url_generate(parent_id, url = '')
      Page.find(parent_id).self_and_ancestors.map {|c| c.url}.append(url).join('/')
    end

    def field(code_name)
      Field.find_by_code_name_and_template_id code_name, template_id
    end

    def get_field_value(code_name, meth = 'value')
      field = field(code_name)
      field.get_value_for(self, meth) if field
    end

    def find_page_in_branch_template(code_name)
      _template = Template.find_by_code_name code_name.singularize

      if _template
        result = []
        result = descendants.where(template_id: _template.id) if code_name == code_name.pluralize
        result = ancestors.find_by_template_id(_template.id) if result.empty?
        result
      end
    end

    alias_method :find_pages_in_branch_template, :find_page_in_branch_template

    def set_field_value(code_name, value, meth = 'value')
      field = field(code_name)
      field.set_value_for(self, value, meth) if field
    end

    def active?; active end

    def as_json(options = {})
      options = {name: self.name, title: self.title}.merge options

      template.fields.each do |field|
        options = {field.code_name.to_sym => field.get_value_for(self)}.merge options
      end

      options
    end

    # remove all type fields
    def remove_fields_values
      fields.each {|f| f.remove_values_for self}
    end

    # update all type fields
    def update_fields_values(params)
      fields.each {|f| f.update_value_for(self, params)}
    end

    def method_missing(name, *args, &block)
      name = name.to_s

      if name[-1] == '='
        set_field_value(name[0..-2], args[0])
      else
        get_field_value(name) || find_pages_in_branch_template(name)
      end
    end

    # check if link specified
    def redirect?; url != link && !link.empty? end

    private

    # if url has been changed by manually or url is empty
    def friendly_url
      self.url = ((auto_url || url.empty?) ? translit(name) : url).parameterize
    end

    # TODO: add more languages
    # translit to english
    def translit(str)
      Russian.translit(str)
    end

    # page is not valid if there is no template
    def template_check
      errors.add_on_empty(:template_id) if Template.count == 0
    end

    # if template_id is nil then get first template
    def template_assign
      self.template_id = Template.first.id unless template_id
    end

    def full_url_update
      self.full_url = '/' + (parent_id ? Page.full_url_generate(parent_id, url) : url)
    end

    def descendants_update; descendants.map(&:save) end

    def create_fields
      fields.each {|field| field.type_class.create page_id: id, field_id: field.id}
    end
  end
end