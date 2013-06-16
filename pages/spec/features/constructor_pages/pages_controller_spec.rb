# encoding: utf-8

require 'spec_helper'
require 'capybara/rspec'

module ConstructorPages
  describe 'Page Controller', type: :feature do
    it 'should be valid' do
      visit '/'
    end
  end
end