# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe 'Templates Controller' do
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

      login_as @user
    end

    describe 'Index' do
      it 'should be accessed by pages.templates_path if logged in' do
        visit pages.templates_path
        current_path.should == pages.templates_path
        status_code.should == 200
      end

      it 'should not be accessed by pages.templates_path if not logged in' do
        logout
        visit pages.templates_path
        current_path.should == '/'
      end

      it 'should has new template link' do
        visit pages.templates_path
        page.should have_link 'New template', pages.new_template_path
      end

      it 'should has list of templates' do
        Template.create name: 'Page', code_name: 'page'
        visit pages.templates_path
        page.should have_selector 'ul li'
        page.should have_text 'Page'
      end

      it 'should has edit_template link' do
        _template = Template.create name: 'Page', code_name: 'page'
        visit pages.templates_path
        page.should have_link 'Edit template', pages.edit_template_path(_template)
      end

      it 'should has delete_page link' do
        _template = Template.create name: 'Page', code_name: 'page'
        visit pages.templates_path
        page.should have_link 'Delete', pages.template_path(_template)
      end
    end

    describe 'Moving' do
      it 'should move template' do
        _template_first = Template.create name: 'First', code_name: 'first'
        _template_second = Template.create name: 'Second', code_name: 'second'
        _template_third = Template.create name: 'Third', code_name: 'third'

        _template_first.left_sibling.should be_nil
        _template_first.right_sibling.should == _template_second

        _template_second.left_sibling.should == _template_first
        _template_second.right_sibling.should == _template_third

        _template_third.left_sibling.should == _template_second
        _template_third.right_sibling.should be_nil

        visit pages.templates_path

        find("a[href='#{pages.template_move_down_path(_template_first.id)}']").click

        _template_first.reload
        _template_first.left_sibling.should == _template_second
        _template_first.right_sibling.should == _template_third

        _template_second.reload
        _template_second.left_sibling.should be_nil
        _template_second.right_sibling.should == _template_first

        _template_third.reload
        _template_third.left_sibling.should == _template_first
        _template_third.right_sibling.should be_nil

        find("a[href='#{pages.template_move_up_path(_template_third.id)}']").click

        _template_first.reload
        _template_first.left_sibling.should == _template_third
        _template_first.right_sibling.should be_nil

        _template_second.reload
        _template_second.left_sibling.should be_nil
        _template_second.right_sibling.should == _template_third

        _template_third.reload
        _template_third.left_sibling.should == _template_second
        _template_third.right_sibling.should == _template_first
      end
    end

    describe 'New template' do
      it 'should be accessed by new_template_path if logged in' do
        visit pages.new_template_path
        current_path.should == pages.new_template_path
        status_code.should == 200
      end

      it 'should not be accessed by new_template_path if not logged in' do
        logout
        visit pages.new_template_path
        current_path.should == '/'
      end

      it 'should has name field' do
        visit pages.new_template_path
        page.should have_field 'Name'
      end

      it 'should has code_name field' do
        visit pages.new_template_path
        page.should have_field 'Code name'
      end

      it 'should has parent and child selects' do
        visit pages.new_template_path
        page.should have_select 'Parent'
        page.should have_select 'Child'
      end

      it 'should not has link new field' do
        visit pages.new_template_path
        page.should_not have_link 'New field'
      end

      it 'should has Create Template button' do
        visit pages.new_template_path
        page.should have_button 'Create Template'
      end

      it 'should create new template' do
        visit pages.new_template_path
        fill_in 'Name', with: 'Brand'
        fill_in 'Code name', with: 'brand'
        Template.count.should == 0
        click_button 'Create Template'
        current_path.should == pages.templates_path
        Template.count.should == 1
        _template = Template.first
        _template.name.should == 'Brand'
        _template.code_name.should == 'brand'
      end

      it 'should validate uniqueness of code name' do
        Template.create name: 'Brand', code_name: 'brand'
        visit pages.new_template_path
        fill_in 'Name', with: 'Brand'
        fill_in 'Code name', with: 'brand'
        click_button 'Create Template'
        current_path.should == pages.templates_path
        page.should have_text 'Code name has already been taken'
      end

      it 'should validate uniqueness of code name with Page' do
        visit pages.new_template_path
        fill_in 'Name', with: 'Brand'
        fill_in 'Code name', with: 'get_field_value'
        Template.count.should == 0
        click_button 'Create Template'
        Template.count.should == 0
        page.should have_text 'Code name has already been taken'
      end
    end
  end
end