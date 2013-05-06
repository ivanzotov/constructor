# encoding: utf-8

module ConstructorPages
  class NumberType < ActiveRecord::Base
    attr_accessible :value, :field_id, :page_id
  end
end