# encoding: utf-8

module ConstructorPages
  module Types
    # Integer type. Render small text field.
    class IntegerType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page
    end
  end
end