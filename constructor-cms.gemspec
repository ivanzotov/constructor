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

  s.files = %w(
    lib/constructor-cms.rb
    lib/constructor-cms/engine.rb
    script/rails
    LICENSE.md
    README.md
    config/routes.rb
  )

  s.add_dependency 'rails', '~> 3.2.13'
  s.add_dependency 'constructor-core'
  s.add_dependency 'constructor-pages'
  s.add_dependency 'acts_as_list'

  s.add_development_dependency 'sqlite3'
end
