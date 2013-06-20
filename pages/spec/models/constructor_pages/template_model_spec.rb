# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe Template do
    before :each do
      Template.delete_all
    end

    it 'should be valid' do
      _template = Template.create name: 'Page template', code_name: 'page_template'
      _template.valid?.should be_true
    end

    describe '#child' do
      it 'should return child corresponding child_id or children first' do
        _brand = Template.create name: 'Brand', code_name: 'brand'
        _series = Template.create name: 'Series', code_name: 'series', parent: _brand
        _brand.reload

        _brand.child.should == _series
        _brand.child_id = _brand.id

        _brand.child.should == _brand
      end
    end
  end
end