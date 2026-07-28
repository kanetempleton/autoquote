require 'capybara/cucumber'
require 'capybara/rspec'
require 'playwright'
require 'rack/test'

# Load the Sinatra app
require_relative '../../app/app'

Capybara.app = Sinatra::Application
Capybara.default_driver = :playwright
Capybara.javascript_driver = :playwright
Capybara.default_max_wait_time = 5

Capybara.register_driver :playwright do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: :chromium,
    headless: true
  )
end

# Make the app available for API tests later
World(Rack::Test::Methods)

def app
  Sinatra::Application
end
