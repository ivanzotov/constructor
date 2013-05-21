# encoding: utf-8

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = %q{constructor-cms}
  s.version = '0.1'
  s.summary = %q{Constructor}
  s.authors = ['Ivan Zotov']
  s.require_paths = %w(lib)
  s.email = "ivanzotov@gmail.com"
  s.homepage = "http://ivanzotov.github.com/constructor"
  s.description = "Constructor – content management system"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_dependency 'constructor-core'
  s.add_dependency 'constructor-pages'
  s.add_dependency 'acts_as_list'
end
