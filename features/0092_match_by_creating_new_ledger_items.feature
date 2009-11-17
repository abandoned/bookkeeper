Feature: Match by Creating a New Ledger Item
  In order to keep the company in order
  As a bookkeeper
  I want to be able to reconcile by matching a ledger item to a newly-created one
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "Bank A/C" exists with name: "Bank A/C", parent: account "Assets"
      And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
      And a contact "Self" exists with name: "Self"
      And a contact "Starbucks" exists with name: "Starbucks"
  
  Scenario: Create a matching item to balance the cart
    Given a ledger_item exists with id: 1, total_amount: "2.99", currency: "USD", account: account "Bank A/C", sender: contact "Self", recipient: contact "Starbucks"
    When I go to path "/ledger_items"
      And I press "Match" within "#ledger_item_1"
      And I select "Coffee" from "Account"
    When I press "Create match"
    Then I should see "Ledger item successfully reconciled"
      And I should not see "Matches"

  Scenario: Try to create a matching item when there is more than one transaction in the cart
    Given a ledger_item exists with id: 1, total_amount: "2.99", currency: "USD", account: account "Bank A/C", sender: contact "Self", recipient: contact "Starbucks"
      And a ledger_item exists with id: 2, total_amount: "2.99", currency: "USD", account: account "Bank A/C", sender: contact "Self", recipient: contact "Starbucks"
    When I go to path "/ledger_items"
      And I press "Match" within "#ledger_item_1"
      And I press "Match" within "#ledger_item_2"
    Then I should not see a button called "Create match" within "#cart"
