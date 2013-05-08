# encoding: utf-8

module ConstructorPages
  module Types
    class AddressType < ActiveRecord::Base
      attr_accessible :value, :field_id, :page_id
      validates_presence_of :value

      belongs_to :field
      belongs_to :page

=begin
      before_save :url_prepare
      after_update :full_url_descendants_change

      before_update :full_url_change
      before_create :full_url_create


      private
      def full_url_change
        if self.page.parent_id
          self.full_url = '/' + Page.find(parent_id).self_and_ancestors.map {|c| c.url}.append(self.url).join('/')
        else
          self.full_url = '/' + self.url
        end
      end

      def full_url_create
        if self.parent.nil?
          self.full_url = '/' + self.url
        else
          self.full_url = self.parent.full_url + '/' + self.url
        end
      end

      def full_url_descendants_change
        self.descendants.each { |c| c.save }
      end

      def url_prepare
        if self.auto_url or self.url.empty?
          self.url = self.title.parameterize
        else
          self.url = self.url.parameterize
        end
      end
=end
    end
  end
end