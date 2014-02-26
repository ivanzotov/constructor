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

    before_update {|t|
      t.connection.execute("DROP VIEW IF EXISTS #{code_name_was.pluralize}")
    }

    after_save {|t|
      t.connection.execute(
        """
          CREATE VIEW #{code_name.pluralize} AS
          SELECT pages.id, pages.active, pages.url, pages.full_url, pages.name
                 #{t.fields.map{|f| ',' + f.code_name + '.value AS ' + f.code_name }.join}
          FROM constructor_pages_pages AS pages
          #{t.fields.map{|f|
            "LEFT OUTER JOIN constructor_pages_#{f.type_value}_types AS #{f.code_name}
             ON #{f.code_name}.page_id = pages.id AND #{f.code_name}.field_id = #{f.id}"
          }.join(' ')}
          WHERE pages.template_id = #{t.id}
        """
      )
    }

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

    private

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