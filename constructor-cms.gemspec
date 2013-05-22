# encoding: utf-8

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = %q{constructor-cms}
  s.version = '0.2.3'
  s.summary = %q{ConstructorCms}
  s.authors = ['Ivan Zotov']
  s.require_paths = %w(lib)
  s.email = "ivanzotov@gmail.com"
  s.homepage = "http://ivanzotov.github.com/constructor"
  s.description = "Constructor – content management system"

  s.files = ['lib/constructor-cms.rb', 'lib/constructor-cms/engine.rb', 'config/routes.rb']

  s.add_dependency 'constructor-core'
  s.add_dependency 'constructor-pages'
  s.add_dependency 'acts_as_list'
end
