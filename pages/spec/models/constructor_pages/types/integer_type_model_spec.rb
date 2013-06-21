# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  module Types
    describe 'Integer type' do
      it 'should contain integer type values' do
        Template.delete_all
        _template = Template.create name: 'Product', code_name: 'product'
        _field = Field.create name: 'Amount', code_name: 'amount', template: _template, type_value: 'integer'
        _page = Page.create name: 'TV', template: _template
        _integer = IntegerType.create value: 10, field: _field, page: _page
        _integer.value.should == 10
        _integer.update value: 50.123
        _integer.reload
        _integer.value.should == 50
        _integer.update value: '1000'
        _integer.reload
        _integer.value.should == 1000
      end
    end
  end
end