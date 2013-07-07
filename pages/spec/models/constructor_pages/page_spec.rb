# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe Page do
    before :each do
      Template.delete_all
      @template = Template.create name: 'Page', code_name: 'page'

      Page.delete_all
      Field.delete_all
      Types::TextType.delete_all
    end

    context 'CLASS METHODS' do
      describe '.create' do
        it 'should be valid' do
          Page.create.valid?.should be_true
        end

        it 'should create type_fields after' do
          field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
          page = Page.create(name: 'New page', template: @template)
          field.get_value_for(page).should == ''
        end
      end

      describe '.find_by_request_or_first' do
        before :each do
          @first_page = Page.create name: 'New page'
          @second_page = Page.create name: 'Second page'
        end

        it 'should return page by given request path' do
          Page.find_by_request_or_first('/new-page').should == @first_page
          Page.find_by_request_or_first('/second-page').should == @second_page
        end

        it 'should return first page if no given request or request is home page' do
          Page.find_by_request_or_first.should == @first_page
          Page.find_by_request_or_first('/').should == @first_page
        end
      end

      describe '.full_url_generate' do
        it 'should generate full_url from parent_id and url' do
          first_page = Page.create name: 'First page', url: 'first-page'
          second_page = Page.create name: 'Second page', url: 'second-page', parent: first_page
          Page.full_url_generate(second_page.id, 'third-page').should == '/first-page/second-page/third-page'
        end
      end

      describe '.check_code_name' do
        it 'should check existing code_name in instance_methods' do
          Page.check_code_name('get_field_value').should be_false
          Page.check_code_name('class').should be_false
          Page.check_code_name('hello_world').should be_true
        end
      end
    end

    describe 'SEARCH' do
      before :each do
        @price_field = Field.create name: 'Price', code_name: 'price', template: @template, type_value: 'float'
        @area_field = Field.create name: 'Area', code_name: 'area', template: @template, type_value: 'integer'

        @brand_template = Template.create name: 'Brand', code_name: 'brand', parent: @template
        @content_field = Field.create name: 'Content', code_name: 'content', template: @brand_template, type_value: 'text'
        @check_field = Field.create name: 'Check', code_name: 'check', template: @brand_template, type_value: 'boolean'
        @brand_price_field = Field.create name: 'Price', code_name: 'price', template: @brand_template, type_value: 'float'
        @brand_area_field = Field.create name: 'Area', code_name: 'brand_area', template: @brand_template, type_value: 'integer'

        @page = Page.create name: 'Fresco', template: @template
        @page.price = 15000
        @page.area = 35

        @second_page = Page.create name: 'Zanussi', template: @template
        @second_page.price = 1000
        @second_page.area = 10

        @first_brand_page = Page.create name: 'Midea', template: @brand_template, parent: @page
        @first_brand_page.price = 20000
        @first_brand_page.brand_area = 25
        @first_brand_page.content = 'This is first brand page'
        @first_brand_page.check = true

        @second_brand_page = Page.create name: 'Dantex', template: @brand_template, parent: @page
        @second_brand_page.price = 30000
        @second_brand_page.brand_area = 55
        @second_brand_page.content = 'This is second brand page'
        @second_brand_page.check = false
        @second_brand_page.reload

        @third_brand_page = Page.create name: 'LG', template: @brand_template, parent: @second_page
        @third_brand_page.price = 10000
        @third_brand_page.brand_area = 38
        @third_brand_page.content = 'This is third brand page'
        @third_brand_page.check = true
        @third_brand_page.reload

        @page.reload
        @second_page.reload
      end

      context 'search in all pages' do
        it 'should search with what search' do
          Page.search(:hello).should == []
          Page.search(:brand).should == [@first_brand_page, @second_brand_page, @third_brand_page]
          Page.search(:brands).should == [@first_brand_page, @second_brand_page, @third_brand_page]
        end

        it 'should search with where string search' do
          Page.search_in('/world').should == []
        end

        it 'should search with where page search' do
          Page.search_in(@page).should == [@first_brand_page, @second_brand_page]
          Page.in(@second_page).search(:brands).should == [@third_brand_page]
          Page.in(@second_page).search(:brand).should == [@third_brand_page]
          Page.in(@second_page).search('brand').should == [@third_brand_page]
        end

        it 'should search with by params' do
          @page.reload
          Page.in(@page).search_by(brand_area: 25).should == [@first_brand_page]
          Page.search_by(area: 10).should == [@second_page]
          Page.search_by(price: 15000).should == [@page]
          Page.in(@page).by(brand_area: 25).search(:brand).should == [@first_brand_page]
          Page.in(@second_page).by(brand_area: 38).search(:brand).should == [@third_brand_page]
          Page.in(@second_page).by(brand_area: 40).search(:brand).should == []
          Page.in('/world').search_by(brand_area: 10).should == []
        end

        it 'should search with less' do
          Page.search_by('price<' => '20000').should == [@page, @second_page, @third_brand_page]
        end

        it 'should search with more' do
          Page.search_by('price>' => 20000).should == [@second_brand_page]
        end
      end

      context 'search in certain page' do
        it 'should search with what search' do
          @page.search.should == [@first_brand_page, @second_brand_page]
          @page.search(:hello).should == []
          @page.search(:brand).should == [@first_brand_page, @second_brand_page]
          @second_page.search(:brand).should == [@third_brand_page]
        end

        it 'it should search with by params' do
          @page.search_by(brand_area: 25).should == [@first_brand_page]
          @page.search_by(price: 30000).should == [@second_brand_page]
          @page.by(price: 30000).search.should == [@second_brand_page]
          @page.search_by(area: 10).should == []
          @page.by(area: 10).search.should == []
        end
      end
    end

    context 'INSTANCE METHODS' do
      context 'Getting and setting field value' do
        before :each do
          @template = Template.create name: 'Page template', code_name: 'page_template'
          @page = Page.create name: 'Home page', template: @template
          @field = Field.create name: 'Desc', code_name: 'desc', template: @template, type_value: 'text'
        end

        describe '#get_field' do
          it 'should get value from type_field' do
            @field.set_value_for(@page, 'Hello world')
            @page.get_field_value('desc').should == 'Hello world'
          end
        end

        describe '#set_field' do
          it 'should set value for type_field' do
            @page.set_field_value('desc', 'my world')
            @field.get_value_for(@page).should == 'my world'
          end
        end
      end

      context 'Updating and removing fields values' do
        before :each do
          @template = Template.create name: 'New template', code_name: 'brand'
          @field = Field.create name: 'Price', code_name: 'price', template: @template, type_value: 'float'
          @page = Page.create name: 'New page', template: @template
          @page.price = 500
        end

        describe '#update_fields_values' do
          it 'should update fields values with params' do
            @template.reload
            Field.create name: 'Count', code_name: 'amount', template: @template, type_value: 'integer'

            @page.reload

            @page.amount = 10

            @page.update_fields_values({price: 1000, amount: 20})

            @page.price.should == 1000
            @page.amount.should == 20
          end

          it 'should reset boolean fields' do
            Field.create name: 'Check', code_name: 'check', template: @template, type_value: 'boolean'

            @page.check = true

            @page.update_fields_values({price: 1000})

            @page.price.should == 1000
            @page.check.should be_false
          end
        end

        describe '#remove_fields_values' do
          it 'should destroy all type_values fields' do
            @field.find_type_object(@page).value.should == 500

            @page.remove_fields_values
            @field.find_type_object(@page).should be_nil
          end
        end
      end

      describe '#find_page_in_branch' do
        it 'should find page(s) in same branch pages and templates by template_code_name' do
          brand_template = Template.create name: 'Brand', code_name: 'brand'
          series_template = Template.create name: 'Series', code_name: 'series', parent: brand_template

          brand_page = Page.create name: 'Zanussi', template: brand_template
          series_page = Page.create name: 'Fresco', template: series_template, parent: brand_page
          brand_page.reload

          series_page.find_page_in_branch('brand').should == brand_page
          brand_page.find_pages_in_branch('series').should == [series_page]
        end
      end

      describe '#multipart?' do
        it 'should return true if there is file upload in page fields' do
          Field.create name: 'Photo', code_name: 'photo', template: @template, type_value: 'image'
          _page = Page.create name: 'Product', template: @template
          _page.multipart?.should be_true
        end

        it 'should return false if there is no file upload in page fields' do
          _page = Page.create name: 'Product', template: @template
          _page.multipart?.should be_false
        end
      end

      describe '#as_json' do
        context 'should return page hash attributes with fields' do
          before :each do
            @template = Template.create name: 'Json', code_name: 'json_template'
            @page = Page.create name: 'Test json', template: @template
          end

          it 'should return defaults name and title attrs' do
            @page.as_json.should == {name: @page.name, title: @page.title}
          end

          it 'should add fields to hash' do
            Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
            @page.content = 'Hello world'
            @page.reload

            @page.as_json.should == {name: @page.name, title: @page.title, content: 'Hello world'}
          end
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

      describe '#touch_branch' do
        it 'should touch all pages in same branch' do
          page = Page.create name: 'Hello world'
          second_page = Page.create name: 'Again', parent: page
          page.reload

          updated = second_page.updated_at
          page.touch_branch
          second_page.reload
          second_page.updated_at.should_not == updated
        end
      end
    end

    context 'ATTRIBUTES' do
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

          it 'should translit utf-8' do
            I18n.locale = :ru
            page = Page.create name: 'Проверка'
            page.full_url.should == '/proverka'

            page_two = Page.create name: 'Тест', parent: page
            page_two.full_url.should == '/proverka/test'
            I18n.locale = :en
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

          it 'should doesn\'t parameterize' do
            page = Page.create name: 'Hello', url: 'hello_world_How_Are/You', auto_url: false
            page.url.should == 'hello_world_How_Are/You'
          end
        end
      end

      describe '#in_menu' do
        it 'should be true by default' do
          page = Page.create name: 'Hello'
          page.in_menu.should be_true
        end
      end

      describe '#in_nav' do
        it 'should be true by default' do
          page = Page.create name: 'Hello'
          page.in_nav.should be_true
        end
      end

      describe '#in_map' do
        it 'should be true by default' do
          page = Page.create name: 'Hello'
          page.in_map.should be_true
        end
      end

      describe '#in_url' do
        it 'should be true by default' do
          page = Page.create name: 'Hello'
          page.in_url.should be_true
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
            child_page = Page.create name: 'Child page', url: 'child', auto_url: false, parent: page
            page.reload

            page.full_url.should == '/change-url'
            child_page.full_url.should == '/change-url/child'

            page.url = 'another-change-url'
            page.save
            page.full_url.should == '/another-change-url'

            child_page.reload
            child_page.full_url.should == '/another-change-url/child'
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

        context 'if page in_url false' do
          it 'should generate without url' do
            page = Page.create name: 'Hello world'
            second_page = Page.create name: 'Sub page', url: 'my-world', auto_url: false, parent_id: page.id, in_url: false
            third_page = Page.create name: 'Third page', url: 'third', auto_url: false, parent_id: second_page.id
            page.full_url.should == '/hello-world'
            second_page.full_url.should == '/hello-world/my-world'
            third_page.full_url.should == '/hello-world/third'
          end
        end
      end

      describe 'method_missing' do
        context 'Getting and setting field value' do
          before :each do
            @template = Template.create name: 'Page', code_name: 'page_template'
            @page = Page.create name: 'No method', template: @template
            @field = Field.create name: 'Content', code_name: 'desc', template: @template, type_value: 'text'
          end

          it 'should return value of type_value for missing method' do
            @field.set_value_for(@page, 'my world')
            @page.desc.should == 'my world'
          end

          it 'should set value for type_value for missing method' do
            @page.desc = 'my world 2'
            @field.get_value_for(@page).should == 'my world 2'
          end
        end

        it 'should find page in branch template if no field found' do
          brand_template = Template.create name: 'Brand', code_name: 'brand'
          series_template = Template.create name: 'Series', code_name: 'series', parent: brand_template

          brand_page = Page.create name: 'Zanussi', template: brand_template
          series_page = Page.create name: 'Fresco', template: series_template, parent: brand_page
          brand_page.reload

          series_page.brand.should == brand_page
          brand_page.series.should == [series_page]
        end
      end
    end
  end
end