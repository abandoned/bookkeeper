Feature: Default Ledger
  In order to keep the company books in order
  As a user
  I want to have a default ledger
  
  Background:
    Given I am logged in
    And an account: "Assets" exist with name: "Assets", type: "Asset"
    And an account: "Liabilities" exist with name: "Liabilities", type: "Liability"
    And an account: "Equity" exist with name: "Equity", type: "Equity"
    And an account: "Revenue" exist with name: "Revenue", type: "Revenue"
    And an account: "Expenses" exist with name: "Expenses", type: "Expense"
  
  Scenario: List root accounts"
    When I go to path "/accounts"
    Then I should see "Assets" within "#content ul"
    And I should see "Liabilities" within "#content ul"
    And I should see "Equity" within "#content ul"
    And I should see "Revenue" within "#content ul"
    And I should see "Expenses" within "#content ul"