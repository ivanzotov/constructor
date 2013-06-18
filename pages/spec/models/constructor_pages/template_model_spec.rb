# encoding: utf-8

require 'spec_helper'

module ConstructorPages
  describe Template do
    it 'should be valid' do
      template = Template.create name: 'Page template', code_name: 'page_template'
      template.valid?.should be_true
    end
  end
end