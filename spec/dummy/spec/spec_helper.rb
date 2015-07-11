ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment.rb",  __FILE__)

require "rspec/rails"
require "database_cleaner"
require "shoulda-matchers"

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.order = "random"
end
