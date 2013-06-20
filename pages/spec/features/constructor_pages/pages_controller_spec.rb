# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe 'Pages Controller' do
    before :all do
      @user = ConstructorCore::User.create email: 'ivanzotov@gmail.com'
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
          page.status_code.should == 200
        end

        it 'should not be accessed by pages_path if not loggen in' do
          logout
          visit pages.pages_path
          page.status_code.should == 404
        end
      end

      it 'should notice if no template exists' do
        Template.delete_all
        visit pages.pages_path
        page.has_link? 'New page'
        page.has_content? 'Create at least one template'
      end

      it 'should not notice if template exists' do
        visit pages.pages_path
        page.has_link? 'New page'
        page.has_no_text? 'Create at least one template'
      end

      it 'should contain pages list' do
        Page.create name: 'Zanussi'
        visit pages.pages_path
        page.has_selector? 'ul li'
        page.has_link? 'Zanussi'
      end

      it 'should contain edit_page link' do
        _page = Page.create name: 'Zanussi'
        visit pages.pages_path
        page.has_link? pages.edit_page_path(_page)
      end

      it 'should contain delete_page link' do
        login_as @user
        _page = Page.create name: 'Zanussi'
        visit pages.pages_path
        page.has_link? pages.page_path(_page)
      end
    end

    describe 'Edit page' do
      it 'should be accessed by edit_page_path if logged in' do
        _page = Page.create name: 'Hello world'
        visit pages.edit_page_path(_page)
        page.status_code.should == 200
      end

      it 'should not be accessed by edit_page_path if not logged in' do
        _page = Page.create name: 'Hello world'
        logout
        visit pages.edit_page_path(_page)
        page.status_code.should == 404
      end
    end
  end
end