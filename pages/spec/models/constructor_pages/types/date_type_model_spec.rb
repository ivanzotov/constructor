# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  module Types
    describe 'Date type' do
      it 'should contain date type values' do
        Template.delete_all
        _template = Template.create name: 'Product', code_name: 'product'
        _field = Field.create name: 'Update date', code_name: 'update_date', template: _template, type_value: 'date'
        _page = Page.create name: 'TV', template: _template
        _date = DateType.create value: Time.now, field: _field, page: _page
        _date.value.should == Date.today
        _date.update value: '2013-05-07'
        _date.reload
        _date.value.should == Date.parse('2013-05-07')
      end
    end
  end
end