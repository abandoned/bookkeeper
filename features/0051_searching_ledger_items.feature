Feature: Search Ledger Items
  In order to keep the company in order
  As a user
  I want to be able to search ledger items
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "Bank A/C" exists with name: "Bank A/C", parent: account "Assets"
      And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
      And a ledger_item exists with description: "Coffee", total_amount: "2.99", currency: "USD", account: account "Coffee", transacted_on: "1/1/2009"
      And a ledger_item exists with description: "Hot Chocolate", total_amount: "3.99", currency: "USD", account: account "Coffee", transacted_on: "1/2/2009"
      And a ledger_item exists with description: "Tea", identifier: "Foo bar", total_amount: "1.99", currency: "USD", account: account "Coffee", transacted_on: "1/3/2009"
      And a ledger_item exists with description: "Something purchased", total_amount: "-10", currency: "USD", account: account "Bank A/C", transacted_on: "1/4/2009"
  
  Scenario: Search by description
    Given I am on the path "/ledger_items"
    When I fill in "query" with "Coffee"
      And I press "Search"
    Then I should see "Coffee" within "table"
      And I should not see "Tea" within "table"
  
  Scenario: Search by account type
    Given I am on the path "/ledger_items"
    When I select "Bank A/C" from "account"
      And I press "Search"
    Then I should see "Something purchased" within "table"
      And I should not see "Coffee" within "table"
      And I should not see "Tea" within "table"
  
  Scenario: Search unmatched only
    Given a ledger_item exists with description: "Foo", match_id: "1"
      And I am on the path "/ledger_items"
    When I check "unmatched"
      And I press "Search"
    Then I should see "Coffee" within "table"
    And I should not see "Foo" within "table"
  
  Scenario: Search after a date
  
  Scenario: Search prior to a date
  
  Scenario: Search between two dates