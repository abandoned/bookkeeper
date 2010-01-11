Feature: Match by Creating a New Transaction
  In order to take care of my accounting needs
  As a bookkeeper
  I want to be able to reconcile by matching a ledger item to a newly-created one
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "Starbux" exists with name: "Starbux", parent: account "Assets"
      And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
      And a contact "Self" exists with name: "Self"
      And a contact "Starbux" exists with name: "Starbux"
  
  Scenario: Create a matching item to balance the cart
    Given a ledger_item exists with id: 1, total_amount: "2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux"
    When I go to path "/ledger_items"
      And I press "Match" within "#ledger_item_1"
      And I select "Coffee" from "ledger_item_account_id"
    When I press "Create match"
    Then I should see "Ledger item successfully reconciled"
      And I should not see "Matches"

  Scenario: Try to create a matching item when there is more than one transaction in the cart
    Given a ledger_item exists with id: 1, total_amount: "2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux"
      And a ledger_item exists with id: 2, total_amount: "2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux"
    When I go to path "/ledger_items"
      And I press "Match" within "#ledger_item_1"
      And I press "Match" within "#ledger_item_2"
    Then I should not see a button called "Create match" within "#cart"
