# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe Page do
    before :each do
      Template.delete_all
      Template.create name: 'Page', code_name: 'page'

      Page.delete_all
      Field.delete_all
      Types::TextType.delete_all
    end

    it 'should be valid' do
      Page.create.valid?.should be_true
    end

    describe '.find_by_request_or_first' do
      before :each do
        @page = Page.create name: 'New page', url: 'new-page'
      end

      it 'should return page by given request path' do
        Page.find_by_request_or_first('new-page').should == @page
      end

      it 'should return first page if no given request' do
        Page.find_by_request_or_first.should == @page
      end
    end

    describe '.full_url_generate' do
      it 'should generate full_url from parent_id and url' do
      end
    end

    describe '#set_field' do
      it 'should set value for type_field' do
        template = Template.create name: 'Page template', code_name: 'page_template'
        page = Page.create name: 'Home page', template: template
        field = Field.create name: 'Content', code_name: 'desc', template: template, type_value: 'text'

        page.set_field_value('desc', 'my world')

        field.get_value_for(page).should == 'my world'
      end
    end

    describe '#get_field' do
      it 'should get value from type_field' do
        template = Template.create name: 'Page template', code_name: 'page_template'
        page = Page.create name: 'Home page', template: template
        Field.create name: 'Content', code_name: 'desc', template: template, type_value: 'text'

        page.set_field_value('desc', 'Hello world')
        page.get_field_value('desc').should == 'Hello world'
      end
    end

    describe '#find_page_in_branch_template' do
      it 'should find page in one branch template by code_name' do
        brand_template = Template.create name: 'Brand', code_name: 'brand'
        series_template = Template.create name: 'Series', code_name: 'series', parent: brand_template

        brand_page = Page.create name: 'Zanussi', template: brand_template
        series_page = Page.create name: 'Fresco', template: series_template, parent: brand_page

        series_page.find_page_in_branch_template('brand').should == brand_page
      end
    end

    describe '#as_json' do
      it 'should return page as json format with fields' do
        template = Template.create name: 'JSON', code_name: 'json_template'
        page = Page.create name: 'Hi json', template: template
        Field.create name: 'Content', code_name: 'content', template: template, type_value: 'text'
        page.content = 'Hello world'
        page.as_json.should == {content: 'Hello world', name: page.name, title: page.title}
      end
    end

    describe '#redirect?' do
      it 'should check if link specified or not' do
        page = Page.create name: 'Test redirection'
        page.redirect?.should be_false

        page.link = ''
        page.save

        page.redirect?.should be_false

        page.link = '/hello-redirect'
        page.save

        page.redirect?.should be_true
      end
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

    describe '#update_fields_values' do
      it 'should update fields values with params' do
        template = Template.create name: 'New template', code_name: 'brand'
        Field.create name: 'Price', code_name: 'price', template: template, type_value: 'float'
        Field.create name: 'Check', code_name: 'check', template: template, type_value: 'boolean'

        page = Page.create name: 'New page', template: template

        page.check = true
        page.check.should be_true

        page.update_fields_values({price: 1000})

        page.price.should == 1000
        page.check.should be_false
      end
    end

    describe '#remove_fields_values' do
      it 'should destroy all type_values fields' do
        template = Template.create name: 'New template', code_name: 'template'
        field = Field.create name: 'Price', code_name: 'price', template: template, type_value: 'float'
        page = Page.create name: 'New page', template: template

        page.price = 500
        field.find_type_object(page).value.should == 500

        page.remove_fields_values
        field.find_type_object(page).should be_nil
      end
    end

    describe '#full_url' do
      it 'should be generated from url and ancestors' do
        page = Page.create name: 'Hello'
        page.full_url.should == '/hello'

        page_two = Page.create name: 'World', parent: page
        page_two.full_url.should == '/hello/world'
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

    describe 'translit' do
      it 'should translit utf-8' do
        page = Page.create name: 'Проверка'
        page.full_url.should == '/proverka'

        page_two = Page.create name: 'Тест', parent: page
        page_two.full_url.should == '/proverka/test'
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

    describe 'method_missing' do
      it 'should return value of type_value for missing method' do
        template = Template.create name: 'Page', code_name: 'page_template'
        page = Page.create name: 'No method', template: template
        field = Field.create name: 'Content', code_name: 'desc', template: template, type_value: 'text'
        field.set_value_for(page, 'my world')

        page.desc.should == 'my world'
      end

      it 'should set value for type_value for missing method' do
        template = Template.create name: 'Page', code_name: 'page_templ'
        page = Page.create name: 'No method', template: template
        field = Field.create name: 'Content', code_name: 'desc', template: template, type_value: 'text'

        page.desc = 'my world 2'
        field.get_value_for(page).should == 'my world 2'
      end

      it 'should find page in branch template if no field found' do
        Template.delete_all
        brand_template = Template.create name: 'Brand', code_name: 'brand'
        series_template = Template.create name: 'Series', code_name: 'series', parent: brand_template

        brand_page = Page.create name: 'Zanussi', template: brand_template
        series_page = Page.create name: 'Fresco', template: series_template, parent: brand_page

        series_page.brand.should == brand_page
      end
    end
  end
end