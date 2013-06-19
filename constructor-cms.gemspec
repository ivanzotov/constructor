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

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_dependency 'constructor-core', ConstructorCore::VERSION
  s.add_dependency 'constructor-pages', ConstructorCore::VERSION

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '2.14.0.rc1'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'capybara'
end
