# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

require 'kaminari/sinatra'
require 'action_dispatch/http/mime_type' # avoid problem of kaminari

require 'carrierwave'
require 'carrierwave/orm/activerecord'

## OmniAuth
OmniAuth.config.logger = Padrino.logger

##
# ## Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure your I18n
#
I18n.default_locale = :ja
I18n.enforce_available_locales = false
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
  Dotenv.load
  Time.zone_default = ActiveSupport::TimeZone['Tokyo']

  Padrino::Application.load_paths << File.join(Padrino.root, 'uploaders')
  uploaders_path = File.join(Padrino.root, 'uploaders/**/*.rb')
  Padrino.dependency_paths << uploaders_path
  Padrino.require_dependencies(uploaders_path)
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
