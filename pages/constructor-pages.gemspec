# encoding: utf-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{constructor-pages}
  s.version           = '0.3.1'
  s.summary           = %q{Pages for ConstructorCms}
  s.authors           = ['Ivan Zotov']
  s.require_paths     = %w(lib)
  
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
    
  s.add_dependency 'dragonfly'
  s.add_dependency 'rack-cache'
  s.add_dependency 'awesome_nested_set', '~> 2.0'
  s.add_dependency 'haml-rails'
  s.add_dependency 'aws-s3'
  s.add_dependency 'russian', '~> 0.6.0'
  s.add_dependency 'RedCloth'  
end
