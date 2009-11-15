Feature: Default Ledger
  In order to keep the company books in order
  As a user
  I want to have a default ledger
  
  Background:
    Given I am logged in
  
  Scenario: List root accounts
    Given an account: "Assets" exist with name: "Assets"
    And an account: "Liabilities" exist with name: "Liabilities"
    And an account: "Equity" exist with name: "Equity"
    And an account: "Income" exist with name: "Income"
    And an account: "Expenses" exist with name: "Expenses"
    When I go to path "/accounts"
    Then I should see "Assets" within "#main ul"
    And I should see "Liabilities" within "#main ul"
    And I should see "Equity" within "#main ul"
    And I should see "Income" within "#main ul"
    And I should see "Expenses" within "#main ul"