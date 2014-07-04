RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require 'capybara/rspec'
require 'capybara-webkit'
require 'capybara/poltergeist'

Dir[
  Padrino.root("spec/factories/**/*.rb"),
  Padrino.root("spec/support/**/*.rb"),
].each {|f| require f}

Capybara.default_driver = :webkit
Capybara.javascript_driver = :poltergeist
Capybara.app = Padrino.application

RSpec.configure do |conf|
  conf.order = "random"
  conf.include Rack::Test::Methods
  conf.include RSpec::Padrino
  conf.include FactoryGirl::Syntax::Methods
  conf.include Capybara::DSL
  conf.include LoginHelper::Feature

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
    provider: 'twitter',
    uid: '12345',
    info: {
      nickname: 'tyabe',
      image: 'http://example.com/tyabe.jpg'
    }
  })

  conf.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  conf.before(:each, js: true) do
    DatabaseCleaner.start
  end
  conf.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end
  conf.after(:each) do
    DatabaseCleaner.clean
  end
end

def app
  @app ||= AmazingEvents::App.tap {|app| app.setup_application! }
end

def session
  last_request.env['rack.session']
end

def root_path
  app.url(:welcome, :index)
end
