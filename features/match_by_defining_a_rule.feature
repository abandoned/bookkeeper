Feature: Match by Defining a Rule
  In order to do proper accounting
  As a bookkeeper
  I want to be able to reconcile a ledger item by defining a rule that will match the item in question as well as other items that the rule matches

  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "Starbux" exists with name: "Starbux", parent: account "Assets"
      And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
      And a contact "Self" exists with name: "Self"
      And a contact "Starbux" exists with name: "Starbux"
  
  Scenario: Create a rule to balance the cart
    Given a ledger_item exists with id: 1, total_amount: "2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux", description: "Cappucino Coffee"
    When I go to path "/ledger_items"
      And I press "Match" within "#ledger_item_1"
      And I press "Set up rule"
      And I fill in "Coffee" for "Matched description"
      And I select "Coffee" from "New account"
      And I press "Submit"
    Then I should see "Successfully created rule"
    Given a ledger_item exists with id: 3, total_amount: "3.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux", description: "Latte Coffee"
    When I go to path "/ledger_items"
    Then I should see "View matches" within "#ledger_item_1"
      And I should see "View matches" within "#ledger_item_3"
  
  Scenario: When I edit a ledger item that is matched with another transaction through a rule, the latter should be updated
    Given a rule exists with account: account "Starbux", matched_sender: contact "Self", matched_recipient: contact "Starbux", matched_debit: false, new_account: account "Coffee"
      And a rule exists with account: account "Starbux", matched_sender: contact "Starbux", matched_recipient: contact "Self", matched_debit: true, new_account: account "Coffee"
      And a ledger_item "l1" exists with id: 1, total_amount: "-2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux"
     Then a match should exist
      And ledger_item "l1" should be matched
      And a ledger_item should exist with total_amount: "2.99", account: account "Coffee", sender: contact: "Starbux", recipient: contact "Self"
     When I go to path "/ledger_items/1/edit"
      And I fill in "Total Amount" with "1"
      And I select "Starbux" from "Sender"
      And I select "Self" from "Recipient"
      And I press "Submit"
    Then I should see "Successfully updated ledger item."
      And a ledger_item should exist with total_amount: "-1", sender: contact "Self", recipient: contact "Starbux"
      And 1 matches should exist
     When I go to path "/ledger_items/2/edit"
      And I fill in "Total Amount" with "5"
      And I select "Starbux" from "Sender"
      And I select "Self" from "Recipient"
      And I press "Submit"
    Then I should see "Successfully updated ledger item."
      And a ledger_item should exist with total_amount: "-5", sender: contact "Self", recipient: contact "Starbux"
      And 1 matches should exist