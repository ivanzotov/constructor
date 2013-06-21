ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]

SimpleCov.start 'rails'

ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../') unless defined?(ENGINE_RAILS_ROOT)

require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'

include Warden::Test::Helpers
Warden.test_mode!

Rails.backtrace_cleaner.remove_silencers!

Dir[File.join(ENGINE_RAILS_ROOT, 'spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.mock_with :rspec
end
