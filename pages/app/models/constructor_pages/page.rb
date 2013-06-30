# encoding: utf-8

module ConstructorPages
  # Page model. Pages are core for company websites, blogs etc.
  class Page < ActiveRecord::Base
    include ActiveSupport::Inflector

    # Adding has_many for all field types
    Field::TYPES.each do |t|
      class_eval %{has_many :#{t}_types,  dependent: :destroy, class_name: 'Types::#{t.titleize}Type'}
    end

    has_many :fields, through: :template
    belongs_to :template

    default_scope -> { order :lft }

    validate :template_check

    before_save :friendly_url, :template_assign, :full_url_update
    after_update :descendants_update
    after_create :create_fields_values

    acts_as_nested_set

    class << self
      # Used for find page by request. It return first page if no request given or request is home page
      # @param request for example <tt>'/conditioners/split-systems/zanussi'</tt>
      def find_by_request_or_first(request = nil)
        (request.nil? || request == '/') ? Page.first : Page.find_by(full_url: request)
      end

      # Generate full_url from parent id and url
      # @param parent_id integer
      # @param url should looks like <tt>'hello-world-page'</tt> without leading slash
      def full_url_generate(parent_id, url = '')
        '/' + Page.find(parent_id).self_and_ancestors.map(&:url).append(url).join('/')
      end

      # Check code_name for field and template.
      # When missing method Page find field or page in branch with plural and singular code_name so
      # field and template code_name should be uniqueness for page methods
      def check_code_name(code_name)
        [code_name, code_name.pluralize, code_name.singularize].each {|name|
          return false if Page.instance_methods.include?(name.to_sym)}
        true
      end

      def search(what_search = nil)
        hash_search, array_search = {}, []

        @where_search = Page.find_by(full_url: @where_search) if @where_search.is_a?(String)
        array_search = ['lft > ? and rgt < ?', @where_search.lft, @where_search.rgt] if @where_search

        what_search && what_search = what_search.to_s.singularize.downcase
        hash_search[:template_id] = ConstructorPages::Template.find_by(code_name: what_search).try(:id) if what_search

        hash_search[:id] = ids_by_params(@params_search) if @params_search

        @where_search = @params_search = nil

        hash_search.empty? && array_search.empty? ? [] : Page.where(hash_search).where(array_search).to_a
      end

      def in(where_search  = nil); tap {@where_search  = where_search}  end
      def by(params_search = nil); tap {@params_search = params_search} end

      def search_in(where_search  = nil); self.in(where_search).search  end
      def search_by(params_search = nil); self.by(params_search).search end


      def ids_by_params(params)
        _hash = {}

        params.each_pair do |key, value|
          next if key == 'utf8'

          key = key.to_s
          _key, _value = key.gsub(/>|</, ''), value

          if _value.is_a?(String)
            next if _value.strip.empty?
            _value = _value.gsub(/>|</, '')
            _value = _value.numeric? ? _value.to_f : (_value.to_boolean if _value.boolean?)
          end

          sign = '='

          if key =~ />$/ || value =~ /^>/
            sign = '>'
          elsif key =~ /<$/ || value =~ /^</
            sign = '<'
          end

          _fields = ConstructorPages::Field.where(code_name: _key)

          _ids = []

          _fields.each do |_field|
            _hash[:field_id] = _field.id
            _ids << _field.type_class.where("value #{sign} ?", _value).where(_hash).map(&:page_id)
          end

          _hash[:page_id] = _ids.flatten.uniq
        end

        return _hash[:page_id] || []
      end
    end

    def search(what_search = nil); Page.in(self).search(what_search) end
    def by(params_search = nil); Page.by(params_search); self end
    def search_by(params_search = nil); Page.by(params_search).in(self).search end

    # Get field by code_name
    def field(code_name)
      Field.find_by code_name: code_name, template_id: template_id
    end

    # Get value of field by code_name
    def get_field_value(code_name); field(code_name).try(:get_value_for, self) end

    # Set value of field by code_name and value
    def set_field_value(code_name, value); field(code_name).try(:set_value_for, self, value) end

    # Update all fields values with given params.
    # @param params should looks like <tt>{price: 500, content: 'Hello'}</tt>
    # @param reset_booleans reset all boolean fields to false before assign params
    def update_fields_values(params, reset_booleans = true)
      params || return

      fields.each {|f| f.find_type_object(self).tap {|t| t || break
        t.value = 0 if f.type_value == 'boolean' && reset_booleans
        params[f.code_name.to_sym].tap {|v| v && t.value = v}
        t.save }}
    end

    # Create fields values
    def create_fields_values; fields.each {|f| f.create_type_object self} end

    # Remove all fields values
    def remove_fields_values; fields.each {|f| f.remove_type_object self} end

    # Search page by template code_name in same branch of pages and templates.
    # It allows to call page.category.brand.series.model etc.
    #
    # Return one page if founded in ancestors,
    # and return array of pages if founded in descendants
    #
    # It determines if code_name is singular or nor
    # @param cname template code name
    def find_page_in_branch(cname)
      Template.find_by(code_name: cname.singularize).tap {|t| t || return
        (descendants.where(template_id: t.id) if cname == cname.pluralize).tap {|r| r ||= []
          return r.empty? ? ancestors.find_by(template_id: t.id) : r}}
    end

    alias_method :find_pages_in_branch, :find_page_in_branch

    def published?; active? end

    # Return true if there is a file upload field in page
    def multipart?
      fields.each {|f| return true if f.type_value == 'image'}
      false
    end

    # Returns page hash attributes with fields.
    #
    # Default attributes are name and title. Options param allows to add more.
    # @param options default merge name and title page attributes
    def as_json(options = {})
      {name: self.name, title: self.title}.merge(options).tap do |options|
        fields.each {|f| options.merge!({f.code_name.to_sym => f.get_value_for(self)})}
      end
    end

    # Check if link specified
    def redirect?; url != link && !link.empty? end

    # Touch all pages in same branch
    def touch_branch
      [ancestors, descendants].each {|p| p.map(&:touch)}
    end

    # When method missing it get/set field value or get page in branch
    #
    # Examples:
    #   page.content = 'Hello world'
    #   puts page.price
    #   page.brand.models.each do...
    def method_missing(name, *args, &block)
      super && return if new_record?
      name = name.to_s
      name[-1] == '=' ? set_field_value(name[0..-2], args[0]) : get_field_value(name) || find_pages_in_branch(name)
    end

    private

    # if url has been changed by manually or url is empty
    def friendly_url
      self.url = ((auto_url || url.empty?) ? transliterate(name, '') : url).parameterize
    end

    # Page is not valid if there is no template
    def template_check; errors.add_on_empty(:template_id) if Template.count == 0 end

    # If template_id is nil then get first template
    def template_assign; self.template_id = Template.first.id unless template_id end

    # Update full_url
    def full_url_update
      self.full_url = (parent_id ? Page.full_url_generate(parent_id, url) : '/' + url)
    end

    # Reload all descendants
    def descendants_update
      descendants.map(&:save) if self.full_url_changed?
    end
  end
end