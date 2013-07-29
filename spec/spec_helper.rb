ENV['RACK_ENV'] = 'test'

require_relative '../lib/helios.rb'
require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'rack/test'
require 'pry'
require 'json_spec'
require 'factory_girl'
require 'database_cleaner'

def db_uri
  "postgres://localhost/test_helios"
end

def app
  Helios::Application.new do
      service :data, model: Dir['example/*.xcdatamodel*'].first, only: [:create, :read, :destroy, :update]
      service :push_notification, frontend: false, apn_certificate: 'LICENSE', apn_environment: 'development'
      service :in_app_purchase
      service :passbook
      service :newsstand
  end
end

def last_json
  last_response.body
end

def json_hash
  JSON.parse(last_json)
end

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rack::Test::Methods
  config.include JsonSpec::Helpers
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DB = Sequel.connect(db_uri)
    options = { model: Dir['example/*.xcdatamodel*'].first, only: [:create, :read, :destroy, :update] }
    backend = Helios::Backend::Data.new(nil, options)
    DatabaseCleaner[:sequel].strategy = :truncation, {:pre_count => true}
    DatabaseCleaner[:sequel].clean_with(:truncation)
    Dir[File.dirname(__FILE__)+"/factories/*_factory.rb"].each {|file| require file }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    %w(users products push_notification_devices in_app_purchase_receipts in_app_purchase_products).each do |table|
      DB.reset_primary_key_sequence(table.to_sym)
    end
  end
end

Capybara.app = app
Capybara.default_driver = :selenium
#Capybara.javascript_driver = :poltergeist
