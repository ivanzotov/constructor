require 'spec_helper'

module ConstructorPages
  module Types
    describe 'Boolean type' do
      it 'should contain boolean type values' do
        Template.delete_all
        _template = Template.create name: 'Product', code_name: 'product'
        _field = Field.create name: 'Available', code_name: 'available', template: _template, type_value: 'boolean'
        _page = Page.create name: 'TV', template: _template
        _boolean = BooleanType.create value: true, field: _field, page: _page
        _boolean.value.should == true
        _boolean.update value: 0
        _boolean.reload
        _boolean.value.should == false
      end
    end
  end
end