# encoding: utf-8

require 'spec_helper'

describe Nav do
  before :each do
    @item = stub('Nav::Item', :url => '/new-item', :name => "New item")
    @item_2 = stub('Nav::Item', :url => '/new-item-2', :name => 'New item 2')
    
    [@item, @item_2].each do |i| 
      i.stub(:attrs).and_return({:url => i.url, :name => i.name})
      i.stub(:active=) do |arg|
        i.stub(:active).and_return(arg)
      end
    end
    
    @items = [@item, @item_2]
  end

  describe ".select" do
    context "when request arg not given" do
      before :each do
        Nav.request = '/new-item'
        Nav.select(@items)
      end
      
      it "select item if its url eql Nav.request" do
        @item.active.should be_true
      end
      
      it "doesn't select item if its url not eql Nav.request" do
        @item_2.active.should be_false
      end
    end
    
    context "when request arg given" do
      before :each do
        Nav.select(@items, '/new-item-2')
      end
              
      it "select item if its url eql request arg" do
        @item_2.active.should be_true
      end
      
      it "doesn't select item if its url not eql request arg" do
        @item.active.should be_false
      end
    end
  end
 
  describe ".find" do
    it "return found items" do
      Nav.find(@items, {:name => "New item 2"}).should == [@item_2]
    end
    
    it "return [] if no found" do
      Nav.find(@items, {:name => "There is no"}).should be_empty
    end
  end
end