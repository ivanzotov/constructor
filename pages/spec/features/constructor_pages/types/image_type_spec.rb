# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe 'Image type field' do
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

      @template = Template.create name: 'Brand', code_name: 'brand'

      login_as @user
    end

    it 'should upload image' do
      field = Field.create name: 'Logo', code_name: 'logo', type_value: 'image', template: @template
      _page = Page.create name: 'Zanussi'

      visit pages.edit_page_path(_page)
      page.should have_content('Logo')
      attach_file('Logo', Rails.root.to_s+'/app/assets/images/upload_image.png')
      click_button 'Update Page'
      _page.reload
      _page.logo.should_not be_nil
      visit pages.edit_page_path(_page)
      page.should have_selector('img[alt^="Upload image"]')
    end
  end
end