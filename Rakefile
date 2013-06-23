#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'
require 'rspec/core/rake_task'

Dir[File.expand_path('../tasks/**/*', __FILE__)].each {|task| load task}

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = './**/*_spec.rb'
end

task :default => :spec
