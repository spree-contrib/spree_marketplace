require 'coveralls'
Coveralls.wear!

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'
require 'shoulda-matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Requires factories defined in spree_core
require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/url_helpers'
require 'spree_drop_ship/factories'

# Requires factories defined in lib/spree_marketplace/factories.rb
require 'spree_marketplace/factories'

require 'vcr'
VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'tmp/vcr_cassettes'
  c.ignore_localhost = true
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include IntegrationHelpers

  # == URL Helpers
  #
  # Allows access to Spree's routes in specs:
  #
  # visit spree.admin_path
  # current_path.should eql(spree.products_path)
  config.include Spree::TestingSupport::UrlHelpers

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  config.color = true

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Capybara javascript drivers require transactional fixtures set to false, and we use DatabaseCleaner
  # to cleanup after each test instead.  Without transactional fixtures set to false the records created
  # to setup a test will be unavailable to the browser, which runs under a seperate server instance.
  config.use_transactional_fixtures = false

  # Ensure Suite is set to use transactions for speed.
  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  # Before each spec check if it is a Javascript test and switch between using database transactions or not where necessary.
  config.before :each do
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
    # Set some configuration defaults.
    ActionMailer::Base.default_url_options[:host] = 'localhost'
    SpreeMarketplace::Config[:balanced_api_key] = '12e8a77cad5411e290f6026ba7cac9da'
  end

  # After each spec clean the database.
  config.after :each do
    DatabaseCleaner.clean
  end

  # Add VCR to all tests.
  config.around :each do |example|
    vcr_options = example.metadata[:vcr] || { :re_record_interval => 7.days }
    if vcr_options[:record] == :skip
      VCR.turned_off(&example)
    else
      test_name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
      VCR.use_cassette(test_name, vcr_options, &example)
    end
  end

  config.fail_fast = ENV['FAIL_FAST'] || false
end
