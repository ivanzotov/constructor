# encoding: utf-8

require 'spec_helper'

module ConstructorCore
  describe 'String' do
    describe '#accusative' do
      it 'should convert word to accusative' do
        'проверка'.accusative.should == 'проверку'
        'стол'.accusative.should == 'стол'
        'категория'.accusative.should == 'категорию'
      end
    end
  end
end