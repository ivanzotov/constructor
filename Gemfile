source 'http://rubygems.org'

gemspec

group :test do
  gem 'coveralls', require: false
  gem 'simplecov', :require => false
  gem 'guard-rspec'
end

group :assets do
  gem 'sass-rails',   '~> 4.0.1'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.3.0'
end

gem 'jquery-rails'

platform :jruby do
  gem 'activerecord-jdbcsqlite3-adapter', '1.3.0.beta2'
  gem 'therubyrhino', group: :assets
end

platform :ruby do
  gem 'sqlite3'
end
