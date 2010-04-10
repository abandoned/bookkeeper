Feature: Default Ledger
  In order to keep the company books in order
  As a user
  I want to have a default ledger
  
  Background:
    Given an account: "Assets" exist with name: "Assets", type: "AssetOrLiability"
    And an account: "Liabilities" exist with name: "Liabilities", type: "AssetOrLiability"
    And an account: "Equity" exist with name: "Equity", type: "AssetOrLiability"
    And an account: "Revenue" exist with name: "Revenue", type: "RevenueOrExpense"
    And an account: "Expenses" exist with name: "Expenses", type: "RevenueOrExpense"
    And I am logged in
  
  Scenario: List root accounts
    When I go to path "/accounts"
    Then I should see "Assets" within "#main ul"
    And I should see "Liabilities" within "#main ul"
    And I should see "Equity" within "#main ul"
    And I should see "Revenue" within "#main ul"
    And I should see "Expenses" within "#main ul"