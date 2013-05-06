# encoding: utf-8

module ConstructorPages
  class StringType < ActiveRecord::Base
    attr_accessible :value, :field_id, :page_id
  end
end