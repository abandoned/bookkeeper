@verbose
Feature: Search Transactions by Perspective
  In order to do bookkeeping
  I want to filter transactions from the perspective of a self

  Background:
    Given I have a default ledger set up
    And a contact "Self1" exists with name: "Self1", self: true
    And a contact "Self2" exists with name: "Self2", self: true
    And a match exists
    And a ledger_item exists with total_amount: 300, account: account "Assets", sender: contact "Self1", recipient: contact "Self2", match: that match
    And a ledger_item exists with total_amount: -300, account: account "Liabilities", sender: contact "Self2", recipient: contact "Self1", match: that match
    And I am logged in
  
  Scenario: Filter by self1's perspective
    When I am on the path "/transactions"
    And I fill in "query" with "by Self1; in Assets"
    And I press "Search"
    Then there should be 0 results

  Scenario: Filter by self1's perspective
    When I am on the path "/transactions"
    And I fill in "query" with "by Self2; in Assets"
    And I press "Search"
    Then I should see "300.00" within ".currency strong"
    And there should be 1 results
