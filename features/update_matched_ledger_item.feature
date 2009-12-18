Feature: Update matched ledger item
  In order to do proper accounting
  As a user
  I want to be able to update matched ledger items
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And an account "Bank A/c" exists with name: "Bank A/c", parent: account "Assets"
    And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
    And a contact "Self" exists with name: "Self"
    And a contact "Starbux" exists with name: "Starbux"
    And a match exists
    And a ledger_item "L1" exists with total_amount: "-2.99", currency: "USD", account: account "Bank A/c", sender: contact "Self", recipient: contact "Starbux", match: the match
    And a ledger_item "L2" exists with total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self", match: the match
    
  Scenario: Update ledger item
    Given I am on path "/ledger_items/1"
    When I follow "Edit"
    And I fill in "Description" with "Expense"
    And I press "Submit"
    Then I should see "Successfully updated ledger item."
    And a ledger_item "L1" should exist with match: the match, description: "Expense"
    And a ledger_item "L2" should exist with match: the match