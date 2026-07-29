require 'capybara/cucumber'
require 'capybara/rspec'
require 'capybara-playwright-driver'   # ← this is the important one
require 'rack/test'

# Load the Sinatra app
require_relative '../../app/app'

# Load all page objects
Dir[File.join(__dir__, '../../page_objects/**/*.rb')].each { |f| require f }

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

World(Rack::Test::Methods)

def app
  Sinatra::Application
end