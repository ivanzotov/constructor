# encoding: utf-8

require 'spec_helper'

describe Nav::Item do
  describe "@@items" do
    it "default is empty" do
      Nav::Item.items.should == []
    end

    it "cattr_accessor :items" do
      Nav::Item.items = ["items"]
      Nav::Item.items.should == ["items"]
    end
  end
  
  before :each do
    Nav::Item.items.clear    
  end
  
  describe "#initialize" do
    context "when params not given" do
      it "set @attrs default values" do
        item = Nav::Item.new
        item.instance_variable_get(:@attrs).should == {
          :name => "New item",
          :url => "/",
          :options => {},
          :active => false}
      end
    end
    
    context "when params given" do      
      it "merge @attrs with params" do
        item = Nav::Item.new(:name => "Another name", :url => '/another-url')
        item.instance_variable_get(:@attrs).should == {
          :name => "Another name",
          :url => "/another-url",
          :options => {},         
          :active => false}
      end
    end
    
    context "when add is true (default)" do
      it "add self to @@items" do
        item = Nav::Item.new
        Nav::Item.items.should == [item]
      end
    end
    
    context "when add is false" do
      it "doesn't add self to @@items" do
        item = Nav::Item.new({}, false)
        Nav::Item.items.should be_empty
      end
    end
  end
  
  describe "#attrs" do
    it "returns @attrs" do
      item = Nav::Item.new
      item.instance_variable_set(:@attrs, "Attrs")
      item.attrs.should == "Attrs"
    end
  end
  
  describe "#active?" do
    it "returns @attrs[:active]" do
      item = Nav::Item.new
      attrs = item.instance_variable_get(:@attrs)
      attrs.merge!({:active => 'test'})
      item.instance_variable_set(:@attrs, attrs)
      
      item.active.should == 'test'
    end
  end
  
  describe "#extract_options" do
    before :each do
      @item = Nav::Item.new
    end
    
    context "when options is empty" do
      it "output nothing" do
        @item.options = {}
        @item.extract_options.should == ""
      end
    end
    
    context "when options not is empty" do
      it "extract options to html" do
        @item.options = {:class => "active", :id => "item"}
        @item.extract_options.should == " class='active' id='item'"
      end
    end
    
    context "when item active" do
      it "add 'active' to class " do
        @item.active = true
        
        @item.options = {}                
        @item.extract_options.should == " class='active'"
        
        @item.options = {:class => 'default'}
        @item.extract_options.should == " class='default active'"
      end
    end
  end

  describe "#to_s" do
    before :each do
      @item = Nav::Item.new
    end
    
    it "return link with extracted options" do
      @item.active = false
      @item.options[:id] = "item"
      @item.to_s.should == "<li id='item'><a href='#{@item.url}'>#{@item.name}</a></li>"
    end
  end

  describe "#method_missing" do
    before :each do
      @item = Nav::Item.new
    end
    
    context "when @attrs include called method name" do
      context "when method name has equal sign" do
        it "assign arg to @attrs[:method_name]" do
          @item.name = "New name"
          @item.instance_variable_get(:@attrs)[:name].should == "New name"
        end
      end
      
      context "when method name has no equal sign" do
        it "return @attrs[:method_name]" do
          attrs = @item.instance_variable_get(:@attrs)
          attrs.merge!({:name => "New name 2"})
          @item.instance_variable_set(:@attrs, attrs)
          @item.name.should == "New name 2"
        end
      end
    end
    
    context "when @attrs not include called method name" do
      it "raise NoMethodError" do
        expect {@item.no_method}.to raise_error(NoMethodError)
      end
    end
  end
end