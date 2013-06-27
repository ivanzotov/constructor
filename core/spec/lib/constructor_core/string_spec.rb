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

      it 'should convert two words to accusative' do
        'главная страница'.accusative.should == 'главную страницу'
        'страница главная'.accusative.should == 'страницу главную'
      end
    end
  end
end