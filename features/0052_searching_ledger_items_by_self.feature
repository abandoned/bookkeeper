Feature: Search Ledger Items
  In order to keep the company in order
  As a user
  I want to be able to search ledger items by selves
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "Beverages" exists with name: "Beverages", parent: account "Expenses"
      And a contact "Me" exists with name: "Me", self: true
      And a contact "Myself" exists with name: "Myself", self: true
      And a contact "Other" exists with name: "Other", self: false
      And a ledger_item exists with description: "Coffee", total_amount: "2.99", currency: "USD", account: account "Beverages", sender: contact "Other", recipient: contact "Me"
      And a ledger_item exists with description: "Hot Chocolate", total_amount: "3.99", currency: "USD", account: account "Beverages", sender: contact "Other", recipient: contact "Myself"
      And a ledger_item exists with description: "Tea", identifier: "Foo bar", total_amount: "1.99", currency: "USD", account: account "Beverages", sender: contact "Other", recipient: contact "Other"
  
  Scenario: Search for "Me"
    Given I am on the path "/ledger_items"
    When I select "Me" from "contact"
      And I press "Search"
    Then I should see "Coffee" within "table"
      And I should not see "Hot Chocolate" within "table"
      And I should not see "Tea" within "table"
  
  Scenario: Search for "Myself"
    Given I am on the path "/ledger_items"
    When I select "Myself" from "contact"
      And I press "Search"
    Then I should not see "Coffee" within "table"
      And I should see "Hot Chocolate" within "table"
      And I should not see "Tea" within "table"
  
  Scenario: Search for all my selves
    Given I am on the path "/ledger_items"
    When I select "All selves" from "contact"
      And I press "Search"
    Then I should see "Coffee" within "table"
      And I should see "Hot Chocolate" within "table"
      And I should not see "Tea" within "table"