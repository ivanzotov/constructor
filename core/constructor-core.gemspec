# encoding: utf-8

require File.expand_path('../../core/lib/constructor_core/version', __FILE__)

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{constructor-core}
  s.version           = ConstructorCore::VERSION
  s.summary           = %q{Core for Constructor CMS}
  s.summary           = %q{Constructor Core}
  s.authors           = ['Ivan Zotov']
  s.require_paths     = %w(lib)
  s.description       = 'Core for Constructor CMS'
  s.email             = 'ivanzotov@gmail.com'
  
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'rails', '~> 4.0.3'
  s.add_dependency 'devise', '~> 3.0.0.rc'
  s.add_dependency 'slim'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'the_sortable_tree'
  s.add_dependency 'font-awesome-rails', '4.0.3.1'
  s.add_dependency 'cache_digests'
end
