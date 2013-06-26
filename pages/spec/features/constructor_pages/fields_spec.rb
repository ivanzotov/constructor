# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe 'Fields Controller' do
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
      before :each do
        @template = Template.create name: 'Brand', code_name: 'brand'
        @content_field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
        @price_field = Field.create name: 'Price', code_name: 'price', template: @template, type_value: 'float'
      end

      it 'should list all fields of template' do
        visit pages.edit_template_path(@template)
        page.should have_text 'Content'
        page.should have_text 'Price'
      end

      it 'should has edit field link' do
        visit pages.edit_template_path(@template)
        find("a[href='#{pages.edit_template_field_path(@template, @content_field)}']").should be_true
        find("a[href='#{pages.edit_template_field_path(@template, @price_field)}']").should be_true
      end

      it 'should has delete field link' do
        visit pages.edit_template_path(@template)
        find("a[href='#{pages.template_field_path(@template, @content_field)}']").should be_true
        find("a[href='#{pages.template_field_path(@template, @price_field)}']").should be_true
      end

      it 'should has move field link' do
        visit pages.edit_template_path(@template)
        find("a[href='#{pages.field_move_down_path(@content_field)}']").should be_true
        find("a[href='#{pages.field_move_up_path(@price_field)}']").should be_true
      end
    end

    describe 'New field' do
      before :each do
        @template = Template.create name: 'Brand', code_name: 'brand'
      end

      context 'Access' do
        it 'should be accessed by new_field_path if loggen in' do
          visit pages.new_template_field_path(@template)
          current_path.should == pages.new_template_field_path(@template)
          status_code.should == 200
        end

        it 'should not be accessed by new_field_path if not loggen in' do
          logout
          visit pages.new_template_field_path(@template)
          current_path.should == '/'
        end
      end

      context 'Contain' do
        before :each do
          @content_field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
          @price_field = Field.create name: 'Price', code_name: 'price', template: @template, type_value: 'float'
        end

        it 'should has name field' do
          visit pages.new_template_field_path(@template)
          page.should have_field 'Name'
        end

        it 'should has code name field' do
          visit pages.new_template_field_path(@template)
          page.should have_field 'Code name'
        end

        it 'should has select type' do
          visit pages.new_template_field_path(@template)
          page.should have_select 'Type value'
        end

        it 'should has no delete link' do
          visit pages.new_template_field_path(@template)
          page.should_not have_link 'Delete'
        end

        it 'should has Create Field button' do
          visit pages.new_template_field_path(@template)
          page.should have_button 'Create Field'
        end
      end

      it 'should create new field' do
        visit pages.new_template_field_path(@template)
        fill_in 'Name', with: 'Amount'
        fill_in 'Code name', with: 'amount'
        select 'Integer', from: 'Type value'
        Field.count.should == 0
        click_button 'Create Field'
        Field.count.should == 1
        _field = Field.first
        _field.name.should == 'Amount'
        _field.code_name.should == 'amount'
        _field.type_value.should == 'integer'
        current_path.should == pages.edit_template_path(@template)
        page.should have_text 'added successfully'
        page.should have_text 'Amount'
      end

      it 'should validate uniqueness of code_name' do
        visit pages.new_template_field_path(@template)
        fill_in 'Name', with: 'Hello'
        fill_in 'Code name', with: 'get_field_value'
        Field.count.should == 0
        click_button 'Create Field'
        Field.count.should == 0
        current_path.should == pages.template_fields_path(@template)
        page.should have_text 'Code name has already been taken'

        visit pages.new_template_field_path(@template)
        fill_in 'Name', with: 'Hello'
        fill_in 'Code name', with: 'brand'
        Field.count.should == 0
        click_button 'Create Field'
        Field.count.should == 0
        current_path.should == pages.template_fields_path(@template)
        page.should have_text 'Code name has already been taken'

        _field = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'

        visit pages.edit_template_field_path(@template, _field)
        fill_in 'Name', with: 'Hello'
        fill_in 'Code name', with: 'brand'
        Field.count.should == 1
        click_button 'Update Field'
        Field.count.should == 1
        current_path.should == pages.template_field_path(@template, _field)
        page.should have_text 'Code name has already been taken'
      end
    end

    describe 'Edit field' do
      before :each do
        @template = Template.create name: 'Brand', code_name: 'brand'
        @field_content = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
      end

      context 'Access' do
        it 'should be accessed by edit_field_path if loggen in' do
          visit pages.edit_template_field_path(@template, @field_content)
          current_path.should == pages.edit_template_field_path(@template, @field_content)
          status_code.should == 200
        end

        it 'should not be accessed by new_field_path if not loggen in' do
          logout
          visit pages.edit_template_field_path(@template, @field_content)
          current_path.should == '/'
        end
      end

      it 'should has delete link' do
        visit pages.edit_template_field_path(@template, @field_content)
        page.should have_link 'Delete', pages.template_field_path(@template, @field_content)
      end

      it 'should has Update Field button' do
        visit pages.edit_template_field_path(@template, @field_content)
        page.should have_button 'Update Field'
      end

      it 'should edit field' do
        visit pages.edit_template_field_path(@template, @field_content)
        fill_in 'Name', with: 'Long content'
        fill_in 'Code name', with: 'long_content'
        select 'HTML', from: 'Type value'
        click_button 'Update Field'
        @field_content.reload
        @field_content.name.should == 'Long content'
        @field_content.code_name.should == 'long_content'
        @field_content.type_value.should == 'html'
        current_path.should == pages.edit_template_path(@template)
        page.should have_text 'updated successfully'
      end
    end

    describe 'Delete field' do
      before :each do
        @template = Template.create name: 'Brand', code_name: 'brand'
        @field_content = Field.create name: 'Content', code_name: 'content', template: @template, type_value: 'text'
      end

      it 'should delete field from template edit' do
        visit pages.edit_template_path(@template)
        Field.count.should == 1
        find("a[href='#{pages.template_field_path(@template, @field_content)}']").click
        Field.count.should == 0
        current_path.should == pages.edit_template_path(@template)
        page.should have_text 'removed successfully'
      end

      it 'should delete from field edit' do
        visit pages.edit_template_field_path(@template, @field_content)
        Field.count.should == 1
        click_link 'Delete'
        Field.count.should == 0
        current_path.should == pages.edit_template_path(@template)
        page.should have_text 'removed successfully'
      end
    end
  end
end