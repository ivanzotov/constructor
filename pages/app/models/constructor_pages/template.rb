# encoding: utf-8

module ConstructorPages
  class Template < ActiveRecord::Base
    attr_accessible :name, :code_name, :child_id
    validates_presence_of :name

    default_scope order(:lft)

    has_many :pages

    acts_as_nested_set
  end
end