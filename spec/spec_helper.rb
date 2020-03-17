# frozen_string_literal: true

require File.expand_path('dummy/config/environment.rb', __dir__)

ENV['RAILS_ENV'] = 'test'

require 'bundler/setup'
require 'blazar'
require 'database_cleaner'
require 'shoulda-matchers'

# SimpleCov.minimum_coverage 95

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
end

