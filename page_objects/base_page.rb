class BasePage
  include Capybara::DSL

  def initialize
    # Future common methods can go here
  end

  def visit_page(path = '/')
    visit path
  end
end
