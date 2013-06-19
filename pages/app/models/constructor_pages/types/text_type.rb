# encoding: utf-8

module ConstructorPages
  module Types
    # Text type. Render textarea.
    class TextType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page
    end
  end
end