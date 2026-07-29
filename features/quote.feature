Feature: Request an auto insurance quote
  As a user
  I want to submit my age, vehicle year, and ZIP
  So that I can receive a quote

  Scenario: Successful quote request
    Given I am on the quote form page
    When I fill in the form with age "30", vehicle year "2020", and zip "43215"
    And I submit the form
    Then I should see a quote result
    And the quote should include a quote ID and premium

  Scenario: Validation error for missing required field
    Given I am on the quote form page
    When I fill in the form with age "", vehicle year "2020", and zip "43215"
    And I submit the form
    Then I should see an error message