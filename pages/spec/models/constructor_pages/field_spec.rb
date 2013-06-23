# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe Field do
    before :each do
      Template.delete_all
      @template = Template.create name: 'Page', code_name: 'page'

      Field.delete_all
      Field::TYPES.each do |t|
        "constructor_pages/types/#{t}_type".classify.constantize.delete_all
      end
    end

    describe '.create' do
      it 'should be valid' do
        _field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        _field.should be_valid
      end

      it 'should create page fields' do
        _field = Field.create name: 'Price', code_name: 'price', template: @template, type_value: 'text'

        _page = Page.create name: 'Page', template_id: @template.id
        _page.price.should == ''
      end
    end

    describe '#destroy' do
      it 'should destroy page fields' do
        _field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        _page = Page.create name: 'Page', template: @template

        _page.content.should == ''
        _field.destroy
        _page.content.should be_nil
      end
    end

    describe '#type_class' do
      it 'should return constant of type_value' do
        field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'html'
        field.type_class.should == Types::HtmlType

        field.type_value = 'text'
        field.type_class.should == Types::TextType
      end
    end

    describe '#find_type_object' do
      it 'should find one object of type_value by page' do
        field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        page = Page.create name: 'Page', template: @template

        text_type = Types::TextType.find_by_field_id_and_page_id field.id, page.id

        field.find_type_object(page).should == text_type
      end
    end

    describe '#create_type_object' do
      it 'should create object of type_value by page' do
        field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        page = Page.create name: 'Page', template: @template

        text_type = field.create_type_object(page)
        text_type.should be_an_instance_of(Types::TextType)
        text_type.page_id.should == page.id
        text_type.field_id.should == field.id
      end
    end

    describe '#remove_type_object' do
      it 'should remote object of type_value by page' do
        field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        page = Page.create name: 'Page', template: @template

        field.find_type_object(page).should be_an_instance_of(Types::TextType)

        field.remove_type_object(page)
        field.find_type_object(page).should be_nil
      end
    end

    describe '#get_value_for' do
      it 'should get value of type field by page' do
        field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        page = Page.create name: 'Page', template: @template
        page.content = 'Hello world'

        field.get_value_for(page).should == 'Hello world'
      end
    end

    describe '#set_value_for' do
      it 'should set value for type field by page' do
        field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        page = Page.create name: 'Page', template: @template

        field.set_value_for(page, 'Hello')
        page.content.should == 'Hello'
      end
    end

    describe '#code_name' do
      it 'should be uniqueness in scope fields' do
        Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        _field = Field.create name: 'Content 2', code_name: 'content', template: @template, type_value: 'html'

        _field.should_not be_valid
      end

      it 'should be uniqueness in scope Page' do
        _field = Field.create name: 'Content', code_name: 'get_field_value', template: @template, type_value: 'text'
        _field.should_not be_valid
      end

      it 'should be uniqueness in scope Template branch' do
        _template = Template.create name: 'Brand', code_name: 'brand', parent: @template
        @template.reload

        _field = Field.create name: 'Content', code_name: 'brand', template: @template, type_value: 'text'
        _field.should_not be_valid

        _field.code_name = 'brands'
        _field.should_not be_valid

        _field.code_name = 'price'
        _field.should be_valid
      end
    end
  end
end