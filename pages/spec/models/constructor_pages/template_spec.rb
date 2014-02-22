require 'spec_helper'

module ConstructorPages
  describe Template do
    before :each do
      Template.delete_all
    end

    it 'should be valid' do
      _template = Template.create name: 'Page template', code_name: 'page_template'
      _template.valid?.should be_true
    end

    it 'should be uniqueness with Page' do
      _template = Template.create name: 'Page', code_name: 'get_field_value'
      _template.valid?.should be_false
    end
  end
end