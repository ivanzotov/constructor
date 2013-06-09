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
  s.executables       = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  
  s.add_dependency 'devise'  
end
