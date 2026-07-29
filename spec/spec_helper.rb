require 'rspec'
require 'rack/test'
require 'json'

# prevent 403 Forbidden errors in tests
ENV['RACK_ENV'] = 'test'
ENV['APP_ENV']  = 'test'


require_relative '../app/app'



RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # Allow the host that Rack::Test uses
  config.before(:each) do
    Sinatra::Application.set :host_authorization, { permitted_hosts: [] }
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
