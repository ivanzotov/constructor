# encoding: utf-8

module ConstructorPages
  module Types
    class BooleanType < ActiveRecord::Base
      attr_accessible :value, :field_id, :page_id

      belongs_to :field
      belongs_to :page
    end
  end
end