# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Capybara
require 'capybara/rspec'
require 'capybara/poltergeist'


# START LOAD SUPPORT FILES
support_root = Rails.root.join('spec', 'support')

# Load Helpers
Dir[support_root.join('helpers', '*.rb')].each do |f|
  require f
end

# Load Contexts
Dir[support_root.join('contexts', '*.rb')].each do |f|
  require f
end

# Load Pages
Dir[support_root.join('pages', '**', '*.rb')].each do |f|
  require f
end

# END LOAD SUPPORT FILES

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  Capybara.javascript_driver = :poltergeist
  Capybara.default_max_wait_time = 2

  config.include FactoryBot::Syntax::Methods
  config.include_context 'request context', type: :request
  config.include_context 'feature context', type: :feature
    # config.include Rails.application.routes.url_helpers, :type => :feature
  # config.include DeviseRequestSpecHelpers, type: :feature
  # config.include Devise::Test::ControllerHelpers, type: :controller

  RSpec.describe "Signing in", js: true do
    # tests that actually execute JavaScript
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end


  # start the transaction strategy as examples are run
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end


### SHOULDA ###

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
