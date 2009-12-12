Feature: Match Existing Ledger Items
  In order to do proper accounting
  As a user
  I want to be able to reconcile by matching existing ledger items
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And an account "Starbux" exists with name: "Starbux", parent: account "Assets"
    And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
    And a contact "Self" exists with name: "Self"
    And a contact "Starbux" exists with name: "Starbux"
      
  Scenario: When I edit a ledger item that is matched with another transaction, the latter should be updated
    Given a match exists
    And a ledger_item "l1" exists with id: 1, total_amount: "-2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux", match: the match
    And a ledger_item "l2" exists with id: 2, total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self", match: the match
    When I go to path "/ledger_items/1/edit"
    And I fill in "Total Amount" with "1"
    And I select "Starbux" from "Sender"
    And I select "Self" from "Recipient"
    And I press "Submit"
    Then I should see "Successfully updated ledger item."
    And ledger_item "l2" should exist with total_amount: "-1", sender: contact "Self", recipient: contact "Starbux"
    And a match should exist

  Scenario: When I edit a ledger item that is matched with two other transactions, the match should be deleted
     Given a match exists
     And a ledger_item "l1" exists with id: 1, total_amount: "-5.98", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux", match: the match
     And a ledger_item "l2" exists with id: 2, total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self", match: the match
     And a ledger_item "l3" exists with id: 3, total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self", match: the match
     When I go to path "/ledger_items/1/edit"
     And I fill in "Total Amount" with "1"
     And I select "Starbux" from "Sender"
     And I select "Self" from "Recipient"
     And I press "Submit"
     Then the match should not exist
     And ledger_item "l1" should not be matched
     And ledger_item "l2" should not be matched
     And ledger_item "l3" should not be matched
     And I should see "Successfully updated ledger item."