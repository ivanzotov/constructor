# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe Field do
    before :each do
      Template.delete_all
      @template = Template.create name: 'Page', code_name: 'page'

      Field.delete_all
    end

    describe '.create' do
      it 'should be valid' do
        _field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        _field.valid?.should be_true
      end

      it 'should validate uniqueness' do
        Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        _field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'

        _field.valid?.should_not be_true
      end
    end
  end
end