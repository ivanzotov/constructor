# encoding: utf-8

require 'spec_helper'

describe Nav::Group do
  before :each do
    @group = Nav::Group.new
    @item = mock('Nav::Item')
  end
  
  describe "#items" do
    it "read @items var" do
      @group.instance_variable_set(:@items, "Hello world")
      @group.items.should == "Hello world"
    end
    
    it "default is empty array" do
      @group.instance_variable_get(:@items).should == []
    end
  end
  
  describe "#add" do
    context "when arg is Hash" do
      it "create new item" do
        Nav::Item.should_receive(:new).with(:name => "New item")
        @group.add({:name => "New item"})
      end
        
      it "add created item to @items" do
        Nav::Item.stub(:new).and_return(@item)
        @group.add({:name => "New item"})
        @group.instance_variable_get(:@items).should == [@item]
      end
    end
    
    context "when arg is not Hash" do
      it "add item to @items" do
        @group.add(@item)      
        @group.instance_variable_get(:@items).should == [@item]
      end
    end
    
    context "when multi-params given" do
      it "add or create items" do
        [@item, @item_2].each {|i| i = mock('Nav::Item') }
      
        Nav::Item.should_receive(:new).with(:name => "New item").and_return(@item_2)
        @group.add(@item, {:name => "New item"}, @item_3)
      
        @group.instance_variable_get(:@items).should == [@item, @item_2, @item_3]
      end
    end
  end
  
  describe "#to_s" do
    it "render joined items" do
      @group.instance_variable_set(:@items, ["item", "item_2"])
      @group.to_s.should == "itemitem_2"
    end
  end
end