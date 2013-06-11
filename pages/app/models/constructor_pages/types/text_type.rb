# encoding: utf-8

module ConstructorPages
  module Types
    class TextType < ActiveRecord::Base
      attr_accessible :value, :field_id, :field, :page_id, :page

      belongs_to :field
      belongs_to :page
    end
  end
end