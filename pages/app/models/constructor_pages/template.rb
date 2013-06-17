# encoding: utf-8

module ConstructorPages
  class Template < ActiveRecord::Base
    attr_accessible :name, :code_name, :child_id, :parent_id

    validates_presence_of :name, :code_name
    validates_uniqueness_of :code_name

    validate :method_uniqueness

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

    def method_uniqueness
      if Page.first.respond_to?(code_name) \
      or Page.first.respond_to?(code_name.pluralize) \
      or Page.first.respond_to?(code_name.singularize) \
      or root.descendants.map{|t| t.code_name unless t.code_name == code_name}.include?(code_name.pluralize) \
      or root.descendants.map{|t| t.code_name unless t.code_name == code_name}.include?(code_name.singularize) \

        errors.add(:base, "Такой метод уже используется")
      end
    end
  end
end