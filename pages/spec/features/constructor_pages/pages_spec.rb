# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe 'Pages Controller' do
    before :all do
      ConstructorCore::User.delete_all
      @user = ConstructorCore::User.create email: 'ivanzotov@gmail.com', password: '123qweASD'
    end

    before :each do
      Page.delete_all
      Field.delete_all
      Template.delete_all

      Field::TYPES.each do |t|
        "constructor_pages/types/#{t}_type".classify.constantize.delete_all
      end

      @template = Template.create name: 'Page', code_name: 'page'

      login_as @user
    end

    describe 'Index' do
      context 'Access' do
        it 'should be accessed by pages_path if loggen in' do
          visit pages.pages_path
          current_path.should == pages.pages_path
          status_code.should == 200
        end

        it 'should not be accessed by pages_path if not loggen in' do
          logout
          visit pages.pages_path
          current_path.should == '/'
        end
      end

      it 'should notice if no template exists' do
        Template.delete_all
        visit pages.pages_path
        page.should_not have_link 'New page'
        page.should have_content 'Create at least one template'
      end

      it 'should not notice if template exists' do
        visit pages.pages_path
        page.should have_link 'New page'
        page.should_not have_text 'Create at least one template'
      end

      it 'should has pages list' do
        Page.create name: 'Zanussi'
        visit pages.pages_path
        page.should have_selector 'ul li'
        page.should have_link 'Zanussi'
      end

      it 'should has new page link' do
        visit pages.pages_path
        page.should have_link 'New page', pages.new_page_path
      end

      it 'should has edit_page link' do
        _page = Page.create name: 'Zanussi'
        visit pages.pages_path
        page.should have_link 'Zanussi', pages.edit_page_path(_page)
      end
    end

    describe 'Show' do
      it 'should show page with its template' do
        _page = Page.create name: 'First page', template: @template
        _template = Template.create name: 'Home page', code_name: 'home_page'
        _second_page = Page.create name: 'Second page', template: _template

        visit _page.full_url
        page.should have_content 'Page'

        visit _second_page.full_url
        page.should have_content 'Home page'
      end

      it 'should redirect if redirect specified' do
        _page = Page.create name: 'First page', template: @template
        _template = Template.create name: 'Home page', code_name: 'home_page'

        visit _page.full_url
        current_path.should == '/first-page'

        _page.redirect = '/second-page'
        _page.save

        visit _page.full_url
        current_path.should == '/second-page'

        visit pages.edit_page_path(_page)
        fill_in 'Redirect', with: '/third-page'
        click_button 'Update Page'

        visit _page.full_url
        current_path.should == '/third-page'
      end
    end

    describe 'New page' do
      describe 'Access' do
        it 'should be accessed by new_page_path if logged in' do
          visit pages.new_page_path
          current_path.should == pages.new_page_path
          status_code.should == 200
        end

        it 'should not be accessed by new_page_path if not logged in' do
          logout
          visit pages.new_page_path
          current_path.should == '/'
        end
      end

      it 'should has published checkbox' do
        visit pages.new_page_path
        page.should have_checked_field 'Active'
      end

      it 'should has name field' do
        visit pages.new_page_path
        page.should have_field 'Name'
      end

      it 'should has no delete link' do
        visit pages.new_page_path
        page.should_not have_link 'Delete'
      end

      it 'should has template select' do
        visit pages.new_page_path
        page.should have_select 'Template'
      end

      it 'should has create button' do
        visit pages.new_page_path
        page.should have_button 'Create Page'
      end

      it 'should save new page' do
        visit pages.new_page_path
        fill_in 'Name', with: 'Hello world'
        Page.count.should == 0
        click_button 'Create Page'
        Page.count.should == 1
        _page = Page.first
        _page.name.should == 'Hello world'
        _page.url.should == 'hello-world'
        current_path.should == pages.pages_path
        page.should have_text 'added successfully'
      end
    end

    describe 'Edit page' do
      before :each do
        @page = Page.create name: 'Hello world'
      end

      describe 'Access' do
        it 'should be accessed by edit_page_path if logged in' do
          visit pages.edit_page_path(@page)
          status_code.should == 200
        end

        it 'should not be accessed by edit_page_path if not logged in' do
          logout
          visit pages.edit_page_path(@page)
          current_path.should == '/'
        end
      end

      it 'should edit with template view' do
        visit pages.edit_page_path(@page)
        page.should have_content 'This page show edit with template'
      end

      it 'should edit with page view if no view found' do
        _template = Template.create name: 'Hello', code_name: 'hello'
        _page = Page.create name: 'Hello', template: _template
        visit pages.edit_page_path(_page)
        page.should_not have_content 'This page show edit with template'
      end

      it 'should has delete link' do
        visit pages.edit_page_path(@page)
        page.should have_link 'Delete'
      end

      it 'should not has template select' do
        visit pages.edit_page_path(@page)
        page.should_not have_select 'Template'
      end

      it 'should edit page' do
        visit pages.edit_page_path(@page)
        fill_in 'Name', with: 'Zanussi'
        fill_in 'Title', with: 'Zanussi conditioners'
        fill_in 'Keywords', with: 'Zanussi, conditioners, Voronezh'
        fill_in 'Description', with: 'Zanussi conditioners Voronezh'
        @page.name.should == 'Hello world'
        click_button 'Update Page'
        @page.reload
        @page.name.should == 'Zanussi'
        @page.url.should == 'zanussi'
        @page.title.should == 'Zanussi conditioners'
        @page.keywords.should == 'Zanussi, conditioners, Voronezh'
        @page.description.should == 'Zanussi conditioners Voronezh'
        page.should have_text 'updated successfully'
      end
    end

    describe 'Delete page' do
      it 'should delete from page' do
        _page = Page.create name: 'Page'
        visit pages.edit_page_path(_page)
        Page.count.should == 1
        click_link 'Delete'
        Page.count.should == 0
        page.should have_text 'removed successfully'
      end
    end

    describe 'Fields' do
      it 'should create fields after create page' do
        Field.create name: 'Short description', code_name: 'short_description', template: @template, type_value: 'text'
        Field.create name: 'Long description', code_name: 'long_description', template: @template, type_value: 'html'

        visit pages.new_page_path
        fill_in 'Name', with: 'Page'
        click_button 'Create Page'
        page.should have_content 'added successfully'

        _page = Page.first
        _page.short_description.should == ''

        visit pages.edit_page_path(_page)

        fill_in 'Short description', with: 'This is short description'
        fill_in 'Long description', with: 'This is long description'

        click_button 'Update Page'

        _page.short_description.should == 'This is short description'
      end
    end
  end
end