# encoding: utf-8

module ConstructorPages
  module Types
    # Float type. Render small text field.
    class FloatType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page
    end
  end
end