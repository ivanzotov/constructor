# encoding: utf-8

module ConstructorPages
  class FloatType < ActiveRecord::Base
    attr_accessible :value, :field_id, :page_id

    belongs_to :field
    belongs_to :page
  end
end