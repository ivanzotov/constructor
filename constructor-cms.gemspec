# encoding: utf-8

require File.expand_path('../core/lib/constructor_core/version', __FILE__)

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = %q{constructor-cms}
  s.version = ConstructorCore::VERSION
  s.summary = %q{ConstructorCms}
  s.authors = ['Ivan Zotov']
  s.require_paths = %w(lib)
  s.email = 'ivanzotov@gmail.com'
  s.homepage = 'http://ivanzotov.github.com/constructor'
  s.description = 'Constructor – content management system'

  s.files             = ['config/routes.rb', 'lib/constructor-cms.rb', 'lib/constructor-cms/engine.rb', 'LICENSE.md', 'README.md', 'Rakefile']
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'constructor-core', ConstructorCore::VERSION
  s.add_dependency 'constructor-pages', ConstructorCore::VERSION

  s.add_development_dependency 'rspec-rails', '~> 2.12'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'launchy'
end
