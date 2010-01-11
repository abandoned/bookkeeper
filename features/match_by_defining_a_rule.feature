Feature: Match by Defining a Rule
  In order to take care of my accounting needs
  As a bookkeeper
  I want to be able to reconcile a ledger item by defining a rule that will match the item in question as well as other items that the rule matches

  Background:
    Given I am logged in
    And I have a default ledger set up
    And I have accounts set up for purchasing beverages
    And I have contacts set up for purchasing beverages
  
  Scenario: Create a rule to balance the cart
    Given a ledger_item exists with id: 1, total_amount: 3.00, currency: "USD", account: account "Beverages", sender: contact "Self", recipient: contact "Coffee Vendor", description: "Coffee"
    When I go to path "/transactions"
    And I press "Match" within "#ledger_item_1"
    And I press "Set up rule"
    And I fill in "Coffee" for "Matched description"
    And I select "Bank Account" from "New account"
    And I press "Submit"
    Then I should see "Successfully created rule"
    Given a ledger_item exists with id: 3, total_amount: 4.00, currency: "USD", account: account "Beverages", sender: contact "Self", recipient: contact "Coffee Vendor", description: "Another Coffee"
    When I go to path "/transactions"
    Then I should see "Bank Account" within "#ledger_item_1"
    And I should see "Bank Account" within "#ledger_item_3"
    And 2 matches should exist
  
  Scenario: When I edit a ledger item that is matched with another transaction through a rule, the latter should be updated
    Given a rule exists with account: account "Bank Account", matched_sender: contact "Self", matched_recipient: contact "Coffee Vendor", matched_debit: false, new_account: account "Beverages"
    And a ledger_item "l1" exists with id: 1, total_amount: -3.00, currency: "USD", account: account "Bank Account", sender: contact "Self", recipient: contact "Coffee Vendor"
    Then a match should exist
    And ledger_item "l1" should be matched
    And a ledger_item should exist with total_amount: 3.00, account: account "Beverages", sender: contact: "Coffee Vendor", recipient: contact "Self"
    When I go to path "/transactions/1/edit"
    And I fill in "Total Amount" with "1"
    And I select "Coffee Vendor" from "Sender"
    And I select "Self" from "Recipient"
    And I press "Submit"
    Then I should see "Successfully updated ledger item."
    And a ledger_item should exist with account: account "Beverages", total_amount: -1.00, sender: contact "Self", recipient: contact "Coffee Vendor"
    And 1 matches should exist
    When I go to path "/transactions/2/edit"
    And I fill in "Total Amount" with "5"
    And I select "Coffee Vendor" from "Sender"
    And I select "Self" from "Recipient"
    And I press "Submit"
    Then I should see "Successfully updated ledger item."
    And a ledger_item should exist with account: account "Bank Account", total_amount: "-5", sender: contact "Self", recipient: contact "Coffee Vendor"
    And 1 matches should exist