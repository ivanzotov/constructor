# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe Page do
    it 'should be valid' do
      page = Page.new
      page.save
      page.valid?.should be_true
    end

    describe '#template' do
      context 'if template_id nil' do
        it 'should be first template' do
          template = Template.first
          page = Page.new
          page.save
          page.template.should == template
        end
      end
    end

    describe '#url' do
      context 'If not edited by hand' do
        it 'should be generated from name' do
          page = Page.new name: 'Hello world'
          page.save
          page.url.should == 'hello-world'
        end
      end
    end
  end

=begin
    describe '#full_url'
        it "should add parent url before if parent selected" do
          page_parent = build(:page, :id => 1, :url => '/hello')
          page = build(:page, :parent_id => page_parent, :title => 'World', :url => ' ')
          page.url.should == '/hello/world'

          # if parent not selected
          page.parent_id = nil
          page.url = ' '
          page.save
          page.url.should == '/world'
        end

        it "should be empty when page not valid" do
          build(:page, :title => "Hello", :url => "/hello")
          page = build(:page, :title => "Hello", :url => "")

          page.should_not be_valid
          page.url.should == ""
        end
      end

      context "Finish cleanup" do
        it "should cleanup url: remove spaces, fix backslashes, unknown chars etc." do
          page = FactoryGirl(:page, :url => "  //Hello!@#$\%^&*() my     WORLD /// привет//    ")
          page.url.should == "\/hello-my-world\/privet"
        end
      end
    end

    describe "Parent" do
      it "should not be same as self" do
        page = build(:page)
        page.parent_id = page.id

        page.save
        page.should have(1).errors
      end
    end

    describe "In nav, in menu, in map" do
      it "should be true by default" do
        page = Page.new
        page.in_nav.should be_true
        page.in_menu.should be_true
        page.in_map.should be_true
      end

      it "should change when given in new method" do
        page = Page.new(:in_nav => false, :in_menu => false, :in_map => false)
        page.in_nav.should be_false
        page.in_menu.should be_false
        page.in_map.should be_false
      end
    end
  end
=end
end