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
      describe 'Access' do
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
      describe 'Access' do
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
      end

      it 'should has name field' do
        visit pages.new_template_path
        page.should have_field 'Name'
      end

      it 'should has code_name field' do
        visit pages.new_template_path
        page.should have_field 'Code name'
      end

      it 'should has parent select' do
        visit pages.new_template_path
        page.should have_select 'Parent'
      end

      it 'should not has link new field' do
        visit pages.new_template_path
        page.should_not have_link 'New field'
      end

      it 'should not has delete link' do
        visit pages.new_template_path
        page.should_not have_link 'Delete template'
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
        page.should have_text 'added successfully'
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

    describe 'Edit template' do
      before :each do
        @template = Template.create name: 'Page', code_name: 'page'
      end

      describe 'Access' do
        it 'should be accessed by edit_template_path if logged in' do
          visit pages.edit_template_path(@template)
          status_code.should == 200
        end

        it 'should not be accessed by edit_template_path if not logged in' do
          logout
          visit pages.edit_template_path(@template)
          current_path.should == '/'
        end
      end

      it 'should has delete link' do
        visit pages.edit_template_path(@template)
        page.should have_link 'Delete template'
      end

      it 'should has new field link' do
        visit pages.edit_template_path(@template)
        page.should have_link 'New field', pages.new_template_field_path(@template)
      end

      it 'should has update template button' do
        visit pages.edit_template_path(@template)
        page.should have_button 'Update Template'
      end

      it 'should edit template' do
        visit pages.edit_template_path(@template)
        fill_in 'Name', with: 'New brand'
        fill_in 'Code name', with: 'new_brand'
        click_button 'Update Template'
        @template.reload
        @template.name.should == 'New brand'
        @template.code_name.should == 'new_brand'
        page.should have_text 'updated successfully'
      end
    end

    describe 'Delete template' do
      it 'should delete from templates index' do
        Template.create name: 'Page', code_name: 'page'
        visit pages.templates_path
        Template.count.should == 1
        click_link 'Delete'
        Template.count.should == 0
        page.should have_text 'removed successfully'
      end

      it 'should delete from template' do
        _template = Template.create name: 'Page', code_name: 'page'
        visit pages.edit_template_path(_template)
        Template.count.should == 1
        click_link 'Delete'
        Template.count.should == 0
        page.should have_text 'removed successfully'
      end

      it 'should not delete if there are any pages' do
        _template = Template.create name: 'Page', code_name: 'page'
        Page.create name: 'Home page', template: _template
        visit pages.edit_template_path(_template)
        Template.count.should == 1
        click_link 'Delete'
        Template.count.should == 1
        page.should have_text 'Delete pages with this template before'
      end
    end
  end
end