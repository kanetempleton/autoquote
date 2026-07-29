require 'capybara/cucumber'
require 'capybara/rspec'
require 'capybara-playwright-driver'
require 'rack/test'

# Load the Sinatra app
require_relative '../../app/app'

# Load all page objects
Dir[File.join(__dir__, '../../page_objects/**/*.rb')].each { |f| require f }

# Allow pointing tests at a running container (or any external URL)
if ENV['APP_URL']
  Capybara.run_server = false
  Capybara.app_host = ENV['APP_URL']
else
  # Default: run the Sinatra app in-process (normal local testing)
  Capybara.app = Sinatra::Application
end

Capybara.default_driver = :playwright
Capybara.javascript_driver = :playwright
Capybara.default_max_wait_time = 5

Capybara.register_driver :playwright do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: :chromium,
    headless: true
  )
end

World(Rack::Test::Methods)

def app
  Sinatra::Application
end