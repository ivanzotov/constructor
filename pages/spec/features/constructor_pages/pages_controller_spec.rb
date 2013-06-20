# encoding: utf-8

require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

module ConstructorPages
  describe 'Pages Controller' do
    before :all do
      @user = ConstructorCore::User.create email: 'ivanzotov@gmail.com', password: '123qweASD'
      @template = Template.create name: 'Page', code_name: 'page'
    end

    before :each do
      Page.delete_all
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

      it 'should contain pages list' do
        Page.create name: 'Zanussi'
        visit pages.pages_path
        page.should have_selector 'ul li'
        page.should have_link 'Zanussi'
      end

      it 'should contain new page link' do
        visit pages.pages_path
        page.should have_link 'New page', pages.new_page_path
      end

      it 'should contain edit_page link' do
        _page = Page.create name: 'Zanussi'
        visit pages.pages_path
        page.should have_link 'Edit page', pages.edit_page_path(_page)
      end

      it 'should contain delete_page link' do
        login_as @user
        _page = Page.create name: 'Zanussi'
        visit pages.pages_path
        page.should have_link 'Delete', pages.page_path(_page)
      end
    end

    describe 'New page' do
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

      it 'should has published checkbox' do
        visit pages.new_page_path
        page.should have_checked_field 'Active'
      end

      it 'should has name field' do
        visit pages.new_page_path
        page.should have_field 'Name'
      end

      it 'should has not delete link' do
        visit pages.new_page_path
        page.should_not have_link 'Delete'
      end

      it 'should has create button' do
        visit pages.new_page_path
        page.should have_button 'Create Page'
      end

      it 'should save new page' do
        visit pages.new_page_path
        fill_in 'Name', with: 'Hello world'
        Page.count.should == 0
        page.click_button 'Create Page'
        Page.count.should == 1
        _page = Page.first
        _page.name.should == 'Hello world'
        _page.url.should == 'hello-world'
        current_path.should == pages.pages_path
      end
    end

    describe 'Edit page' do
      before :each do
        @page = Page.create name: 'Hello world'
      end

      it 'should be accessed by edit_page_path if logged in' do
        visit pages.edit_page_path(@page)
        status_code.should == 200
      end

      it 'should not be accessed by edit_page_path if not logged in' do
        logout
        visit pages.edit_page_path(@page)
        current_path.should == '/'
      end

      it 'should has delete link' do
        visit pages.edit_page_path(@page)
        page.should have_link 'Delete'
      end

      it 'should edit page' do
        visit pages.edit_page_path(@page)

      end
    end
  end
end