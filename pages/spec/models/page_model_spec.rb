# encoding: utf-8

require './../spec/spec_helper'

describe Page do
  describe "Title and Url" do
    before :each do
      Factory(:page, :title => "Hello", :url => '/hello')
    end

    it "should be unique" do
      page = Factory.build(:page, :title => "Hello", :url => '/hello')
      page.should_not be_valid
      page.url = '/hello@#$%^&'
      page.should_not be_valid    
      page.should have(1).error_on(:base)
  
      page.url = "/world"
      page.should be_valid
    end

    it "should be unique even before save" do
      page = Factory.build(:page, :title => "Hello", :url => "")
  
      page.should_not be_valid
      page.should have(1).error_on(:base)
    end
  end
  
  describe "Title" do
    it "should not be empty" do
      page = Factory.build(:page, :title => '  ')
      page.should_not be_valid
      page.should have(1).error_on(:title)
      page.errors[:title].should == ['не может быть пустым']
    
      page.title = "Title"
      page.should be_valid  
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

  describe "Parent" do
    it "should not be same as self" do
      page = Factory(:page)
      page.parent_id = page.id
    
      page.save
      page.should have(1).errors
    end
  end

  describe "Url" do
    context "Fix mistakes if remote" do
      it "should fix http// and http:/" do
        page = Factory(:page, :url => 'http:/myurl.com/')
        page.url.should == 'http://myurl.com/'
      
        page = Factory(:page, :url => 'http//myurl.com/')
        page.url.should == 'http://myurl.com/'
      end
    end
  
    context "If empty or nil" do
      it "should be generated from title" do
        page = Factory(:page, :title => "  //Hello!@#$\%^&*() my     WORLD /// привет//    ", :url => '  ')
        page.url.should == "\/hello-my-world\/privet"
      end
    
      it "should add parent url before if parent selected" do
        page_parent = Factory(:page, :id => 1, :url => '/hello')
        page = Factory(:page, :parent_id => page_parent, :title => 'World', :url => ' ')
        page.url.should == '/hello/world'
      
        # if parent not selected
        page.parent_id = nil
        page.url = ' '
        page.save
        page.url.should == '/world'
      end
    
      it "should be empty when page not valid" do
        Factory(:page, :title => "Hello", :url => "/hello")
        page = Factory.build(:page, :title => "Hello", :url => "")
      
        page.should_not be_valid
        page.url.should == ""
      end
    end
  
    context "Finish cleanup" do
      it "should cleanup url: remove spaces, fix backslashes, unknown chars etc." do
        page = Factory(:page, :url => "  //Hello!@#$\%^&*() my     WORLD /// привет//    ")
        page.url.should == "\/hello-my-world\/privet"
      end
    end
  end
end