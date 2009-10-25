Feature: Default Ledger
  In order to keep the company books in order
  As a bookkeeper
  I want to have a default ledger
  
  Background:
    Given I am logged in as bookkeeper
  
  Scenario: List root accounts
    Given the following ledger account records:
    | name        |
    | Assets      |
    | Liabilities |
    | Equity      |
    | Income      |
    | Expenses    |
    When I go to the list of ledger accounts
    Then I should see "Assets"
    And I should see "Liabilities"
    And I should see "Equity"
    And I should see "Income"
    And I should see "Expenses"