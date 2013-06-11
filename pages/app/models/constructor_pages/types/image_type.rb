# encoding: utf-8

module ConstructorPages
  module Types
    class ImageType < ActiveRecord::Base
      attr_accessible :value, :field_id, :field, :page_id, :page

      belongs_to :field
      belongs_to :page

      image_accessor :value

      validates :value, :presence  => true
      validates_size_of :value, :maximum => 5.megabytes, :message => :incorrect_size
      validates_property :mime_type, :of => :value, :in => %w(image/jpeg image/png image/gif), :message => :incorrect_format
    end
  end
end