# encoding: utf-8

module ConstructorPages
  class Page < ActiveRecord::Base
<<<<<<< HEAD
    attr_accessible :active, :title, :url, :seo_title, :auto_url,
                    :parent_id, :content, :link, 
                    :in_menu, :in_map, 
                    :in_nav, :keywords, :description
                      
    has_many :images, :dependent => :destroy

    default_scope order(:lft)
    
    validates_presence_of :title
=======
    attr_accessible :name, :title, :keywords, :description,
                    :url, :full_url, :active, :auto_url,
                    :parent_id, :link, :in_menu, :in_map,
                    :in_nav, :template_id

    has_many :string_types,:dependent => :destroy, :class_name => "Types::StringType"
    has_many :float_types, :dependent => :destroy, :class_name => "Types::FloatType"
    has_many :boolean_types, :dependent => :destroy, :class_name => "Types::BooleanType"
    has_many :integer_types, :dependent => :destroy, :class_name => "Types::IntegerType"
    has_many :text_types, :dependent => :destroy, :class_name => "Types::TextType"
    has_many :date_types, :dependent => :destroy, :class_name => "Types::DateType"
    has_many :html_types, :dependent => :destroy, :class_name => "Types::HtmlType"
    has_many :image_types, :dependent => :destroy, :class_name => "Types::ImageType"

    belongs_to :template

    default_scope order(:lft)
>>>>>>> develop

    before_save :url_prepare, :content_filter
    after_update :full_url_descendants_change

    before_update :full_url_change
    before_create :full_url_create

    after_create :create_fields
    
    acts_as_nested_set
    
    def self.children_of(page)
      Page.where(:parent_id => page)
    end

    def field(code_name, meth = "value")
      field = ConstructorPages::Field.where(:code_name => code_name, :template_id => self.template_id).first

      if field
        f = "constructor_pages/types/#{field.type_value}_type".classify.constantize.where(:field_id => field.id, :page_id => self.id).first
        f.send(meth) if f
      end
    end

    def method_missing(name, *args, &block)
      name = name.to_s

      if field(name).nil?
        _template = Template.find_by_code_name(name.singularize)
        template_id = _template.id if _template

        if template_id
          result = []
          result = descendants.where(:template_id => template_id) if name == name.pluralize
          result = ancestors.where(:template_id => template_id).first if result.empty?
          result || []
        end
      else
        field(name)
      end
    end

    def as_json(options = {})
      options =  {
        :name => self.name,
        :title => self.title
      }.merge options

      self.template.fields.each do |field|
        unless self.send(field.code_name)
          options = {field.code_name => self.send(field.code_name)}.merge options
        end
      end

      options
    end

    private

    def full_url_change
      if parent_id
        self.full_url = '/' + Page.find(parent_id).self_and_ancestors.map {|c| c.url}.append(self.url).join('/')
      else
        self.full_url = '/' + self.url
      end
    end

    def full_url_create
      if self.parent.nil?
        self.full_url = '/' + self.url
      else
        self.full_url = self.parent.full_url + '/' + self.url
      end
    end

    def full_url_descendants_change
      self.descendants.each { |c| c.save }
    end

    def url_prepare
      if self.auto_url or self.url.empty?
<<<<<<< HEAD
        self.url = self.title.parameterize
=======
        self.url = self.name.parameterize
>>>>>>> develop
      else
        self.url = self.url.parameterize
      end
    end

    def create_fields
      template.fields.each do |field|
        "constructor_pages/types/#{field.type_value}_type".classify.constantize.create(
            :page_id => id,
            :field_id => field.id)
      end
    end
  end
end