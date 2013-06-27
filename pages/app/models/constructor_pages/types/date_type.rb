# encoding: utf-8

module ConstructorPages
  module Types
    # Date time. Render as three select lists (day, month, year).
    class DateType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page, touch: true
    end
  end
end