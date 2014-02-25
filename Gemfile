source 'http://rubygems.org'

gemspec

group :test do
  gem 'coveralls', require: false
  gem 'simplecov', require: false
  gem 'guard-rspec'
end

group :assets do
  gem 'sass-rails',   '~> 4.0.1'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'therubyracer', platforms: :ruby
  gem 'therubyrhino', platforms: :jruby
  gem 'uglifier', '>= 1.3.0'
end

gem 'jquery-rails'

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter', group: :sqlite
  gem 'activerecord-jdbcmysql-adapter', group: :mysql
  gem 'activerecord-jdbcpostgresql-adapter', group: :postgresql
end

platforms :rbx do
  gem 'racc'
  gem 'rubysl', '~> 2.0'
  gem 'psych'
end

platforms :ruby do
  gem 'sqlite3', group: :sqlite
  gem 'mysql2', group: :mysql
  gem 'pg', group: :postgresql
end
