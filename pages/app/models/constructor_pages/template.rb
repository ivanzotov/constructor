# encoding: utf-8

module ConstructorPages
  class Template < ActiveRecord::Base

    # Adding code_name_uniqueness method
    include CodeNameUniq

    attr_accessible :name, :code_name, :child_id, :parent_id, :parent

    validates_presence_of :name, :code_name
    validates_uniqueness_of :code_name
    validate :code_name_uniqueness

    default_scope order(:lft)

    has_many :pages
    has_many :fields

    acts_as_nested_set

    # return child corresponding child_id or children first
    def child
      if child_id.nil? and !leaf?
        children.first
      else
        Template.find child_id
      end
    end

    private

    def check_code_name(code_name)
      [code_name.pluralize, code_name.singularize].each do |name|
        if root.descendants.map{|t| t.code_name unless t.code_name == code_name}.include?(name)
          return false
        end
      end

      true
    end
  end
end