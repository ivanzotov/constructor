# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  module Types
    describe 'Float type' do
      it 'should contain float type values' do
        Template.delete_all
        _template = Template.create name: 'Product', code_name: 'product'
        _field = Field.create name: 'Price', code_name: 'price', template: _template, type_value: 'float'
        _page = Page.create name: 'TV', template: _template
        _float = FloatType.create value: 10.54, field: _field, page: _page
        _float.value.should == 10.54
        _float.update value: '1000.543'
        _float.reload
        _float.value.should == 1000.543
      end
    end
  end
end