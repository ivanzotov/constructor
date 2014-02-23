require File.expand_path('../../core/lib/constructor_core/version', __FILE__)

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{constructor-pages}
  s.version           = ConstructorCore::VERSION
  s.summary           = %q{Pages for Constructor CMS}
  s.authors           = ['Ivan Zotov']
  s.require_paths     = %w(lib)
  s.homepage          = 'http://ivanzotov.github.com/constructor'
  s.description       = 'Pages for Constructor CMS'
  s.email             = 'ivanzotov@gmail.com'
  
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'constructor-core', ConstructorCore::VERSION

  s.add_dependency 'dragonfly', '1.0.3'
  s.add_dependency 'rack-cache'
  s.add_dependency 'activerecord-import'
  s.add_dependency 'awesome_nested_set', '3.0.0.rc2'
  s.add_dependency 'acts_as_list'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
end
