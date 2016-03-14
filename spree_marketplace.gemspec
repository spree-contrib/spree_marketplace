Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_marketplace'
  s.version     = '2.0.0.beta'
  s.summary     = 'Enable Spree to work as a Marketplace.'
  s.description = 'By extending Spree Drop Ship to enable supplier payments Spree works as a Marketplace.'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Jeff Dutil'
  s.email     = 'jdutil@burlingtonwebapps.com'
  s.homepage  = 'https://github.com/jdutil/spree_marketplace'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'stripe'
  s.add_dependency 'spree_core', '~> 3.0.0'
  s.add_dependency 'spree_drop_ship'

  s.add_development_dependency 'capybara', '~> 2.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'rspec-rails', '~> 2.99'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'spree_digital'
  s.add_development_dependency 'spree_editor'
  s.add_development_dependency 'spree_group_pricing'
  s.add_development_dependency 'spree_related_products'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
