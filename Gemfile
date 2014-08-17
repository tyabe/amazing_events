source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'
gem 'omniauth', '~> 1.2.1'
gem 'omniauth-twitter', '~> 1.0.1'
gem 'kaminari', :require => false
gem 'carrierwave', '~> 0.10.0', :require => false
gem 'mini_magick', '~> 3.7.0'

# Component requirements
gem 'erubis', '~> 2.7.0'
gem 'slim'
gem 'activerecord', '>= 3.1', :require => 'active_record'
gem 'sqlite3'

# Test requirements
group :test do
  gem 'rspec'
  gem 'rack-test', :require => 'rack/test'
  gem 'shoulda-matchers', '~> 2.6.0'
  gem 'capybara', '~> 2.2.1'
  gem 'capybara-webkit'
  gem 'poltergeist', '~> 1.5.0'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'rspec-padrino', github: 'udzura/rspec-padrino'
end

group :development, :test do
  gem 'dotenv'
  gem 'factory_girl'
end

# Padrino Stable Gem
gem 'padrino', '0.12.3'

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core support gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.12.2'
# end
