# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe Page do
    before :all do
      Template.delete_all
      Template.create name: 'Page', code_name: 'page'


      Field.delete_all
      Types::TextType.delete_all
    end

    it 'should be valid' do
      page = Page.create
      page.valid?.should be_true
    end

    describe '.field' do
      it 'should get value from type_field' do
        template = Template.create name: 'Page template', code_name: 'page_template'
        page = Page.create name: 'Home page', template: template
        field = Field.create name: 'Content', code_name: 'desc', template: template, type_value: 'text'
        page.field('desc').should == field.text_type.value
      end
    end

    describe '.full_url_generate' do
      it 'should generate full_url from parent_id and url' do
      end
    end

    describe '#as_json' do
      it 'should return page as json format with fields'
    end

    describe '#auto_url' do
      it 'should be true by default' do
        page = Page.create
        page.auto_url.should be_true
      end
    end

    describe '#template' do
      context 'if there is no template' do
        it 'should not be valid' do
          Template.delete_all
          page = Page.create
          page.valid?.should_not be_true
          Template.create name: 'Page', code_name: 'page'
        end
      end

      context 'if template_id is nil' do
        it 'should be first template' do
          page = Page.create
          page.template.should == Template.first
        end
      end
    end

    describe '#url' do
      context 'if url is empty or if auto_url is true' do
        it 'should be generated from name' do
          page = Page.create name: 'Hello world'
          page.url.should == 'hello-world'
        end
      end

      context 'else' do
        it 'should get url field value' do
          page = Page.create name: 'Hello', auto_url: true
          page.url.should == 'hello'

          page.auto_url = false
          page.url = 'world'
          page.save
          page.url.should == 'world'

          page.auto_url = true
          page.name = 'Another world'
          page.url = 'world-two'
          page.save
          page.url.should == 'another-world'
        end
      end
    end

    describe '#full_url' do
      it 'should be generated from url and ancestors' do
        page = Page.create name: 'Hello'
        page.full_url.should == '/hello'

        page_two = Page.create name: 'World', parent: page
        page_two.full_url.should == '/hello/world'
      end

      it 'should be translit utf-8' do
        page = Page.create name: 'Проверка'
        page.full_url.should == '/proverka'

        page_two = Page.create name: 'Тест', parent: page
        page_two.full_url.should == '/proverka/test'
      end

      context 'if parent or url has been changed' do
        it 'should update full_url' do
          page = Page.create name: 'Change url', url: 'change-url', auto_url: false
          page.full_url.should == '/change-url'

          page.url = 'another-change-url'
          page.save
          page.full_url.should == '/another-change-url'
        end
      end

      context 'if parent is root or nil' do
        it 'should be as /self.url' do
          page = Page.create name: 'Page', url: 'page', auto_url: false, parent_id: nil
          page.full_url.should == '/page'

          parent = Page.create name: 'Parent'
          page.parent = parent
          page.save

          page.full_url.should == '/parent/page'

          page.parent = nil
          page.save
          page.full_url.should == '/page'
        end
      end
    end

    describe 'descendants_update' do
      it 'should update descendants full_url' do
        page = Page.create name: 'Update descendants', url: 'update-descendants', auto_url: false
        page_two = Page.create name: 'Child', url: 'child', parent: page
        page_two.full_url.should == '/update-descendants/child'

        page = Page.find(page.id)
        page.url = 'another-update-descendants'
        page.save

        page_two = Page.find(page_two.id)
        page_two.full_url.should == '/another-update-descendants/child'
      end
    end

    describe 'create_fields' do
      it 'should create type_fields after update page'
    end
  end
end