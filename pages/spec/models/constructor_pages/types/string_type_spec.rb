# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  module Types
    describe 'String type' do
      it 'should contain string type values' do
        Template.delete_all
        _template = Template.create name: 'Product', code_name: 'product'
        _field = Field.create name: 'Short description', code_name: 'short_description', template: _template, type_value: 'string'
        _page = Page.create name: 'TV', template: _template
        _string = StringType.create value: 'This is short description', field: _field, page: _page
        _string.value.should == 'This is short description'
        _string.update value: 1000
        _string.reload
        _string.value.should == '1000'
      end
    end
  end
end