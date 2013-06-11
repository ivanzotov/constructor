# encoding: utf-8

module ConstructorPages
  module Types
    class DateType < ActiveRecord::Base
      attr_accessible :value, :field_id, :field, :page_id, :page

      belongs_to :field
      belongs_to :page

      def russian
        Russian::strftime(self.value, "%d %B %Y").gsub(/0(\d\D)/, '\1')
      end
    end
  end
end