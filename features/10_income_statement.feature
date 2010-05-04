Feature: Income Statement
  In order to do bookkeeping
  As a bookkeeper
  I want to be able to generate income statements
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I have conducted some business over the past year
    And I am logged in
  
  @wip
  Scenario: View income statement
    Given I am on path "/reports/income_statement"
    And I fill in "From" with "2008-01-01"
    And I fill in "To" with "2008-12-31"
    And I press "Generate report"
    Then show me the page