module ConstructorPages
  # Template model. Template allows assing different design for pages.
  #
  # Templates has many fields.
  # For example:
  #   template "Product" should has fields like "price", "description", "size" etc.
  class Template < ActiveRecord::Base
    include TheSortableTree::Scopes

    validates_presence_of :name, :code_name
    validates_uniqueness_of :code_name
    validate :code_name_uniqueness

    default_scope -> { order :lft }

    after_destroy :drop_view
    before_update :drop_previous_view
    after_save :create_view

    has_many :pages, dependent: :destroy
    has_many :fields, dependent: :destroy

    acts_as_nested_set

    # Return child corresponding child_id or children first
    def child
      Template.find(child_id) if child_id
    end

    # Convert name to accusative
    def to_accusative
      self.name.mb_chars.downcase.to_s.accusative
    end

    # Drop database view
    def drop_previous_view
      drop_view(code_name_was)
    end

    # Recreate database view
    def create_view
      drop_view

      _fields = fields.map do |f|
        if f.type_value == 'image'
          ',' + f.code_name + '.value_uid AS '  + f.code_name + '_uid' +
          ',' + f.code_name + '.value_name AS ' + f.code_name + '_name'
        else
          ',' + f.code_name + '.value AS ' + f.code_name
        end
      end

      self.connection.execute(
        """
        CREATE VIEW #{code_name.pluralize} AS
          SELECT pages.id,
                 pages.active,
                 pages.url,
                 pages.full_url,
                 pages.name
                 #{_fields.join}
          FROM constructor_pages_pages AS pages
          #{fields.map{|f|
            "LEFT OUTER JOIN constructor_pages_#{f.type_value}_types AS #{f.code_name}
             ON #{f.code_name}.page_id = pages.id AND #{f.code_name}.field_id = #{f.id}"
          }.join(' ')}
          WHERE pages.template_id = #{id}
        """
      )
    end

    private

    def drop_view(code_name = nil)
      code_name ||= self.code_name
      self.connection.execute("DROP VIEW IF EXISTS #{code_name.pluralize}")
    end

    # Check if code_name is not available
    def code_name_uniqueness
      errors.add(:base, :code_name_already_in_use) unless Page.check_code_name(code_name) and check_code_name(code_name)
    end

    # Check if there is code_name in same branch
    def check_code_name(cname)
      [cname.pluralize, cname.singularize].each {|name|
        return false if root.descendants.map{|t| t.code_name unless t.code_name == cname}.include?(name)}
      true
    end
  end
end