# encoding: utf-8

module ConstructorPages
  module Types
    # Boolean type. Render as checkbox.
    class BooleanType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page
    end
  end
end