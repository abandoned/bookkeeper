Feature: Match Existing Ledger Items
  In order to do proper accounting
  As a user
  I want to be able to reconcile by matching existing ledger items
  
  Background:
    Given I am logged in
    And I have a default ledger set up
  
  Scenario: When I edit a ledger item that is matched with another transaction, the latter should be updated
    Given I have a double entry for a beverage purchase
    And a contact "Other Seller" exists with name: "Other Seller"
    When I go to path "/ledger_items/1/edit"
    And I fill in "Total Amount" with "1"
    And I select "Other Seller" from "Sender"
    And I press "Submit"
    Then I should see "Successfully updated ledger item."
    And ledger_item "Purchase" should exist with total_amount: -1.00, sender: contact "Self", recipient: contact "Other Seller"
    And a match should exist

  Scenario: When I edit a ledger item that is matched with two other transactions, the match should be deleted
     Given I have accounts set up for purchasing beverages
     And I have contacts set up for purchasing beverages
     And a match exists
     And a ledger_item "l1" exists with id: 1, total_amount: -6.00, currency: "USD", account: account "Bank Account", sender: contact "Self", recipient: contact "Coffee Vendor", match: the match
     And a ledger_item "l2" exists with id: 2, total_amount: 3.00, currency: "USD", account: account "Beverages", sender: contact "Coffee Vendor", recipient: contact "Self", match: the match
     And a ledger_item "l3" exists with id: 3, total_amount: 3.00, currency: "USD", account: account "Beverages", sender: contact "Coffee Vendor", recipient: contact "Self", match: the match
     When I go to path "/ledger_items/1/edit"
     And I fill in "Total Amount" with "1"
     And I select "Coffee Vendor" from "Sender"
     And I select "Self" from "Recipient"
     And I press "Submit"
     Then the match should not exist
     And ledger_item "l1" should not be matched
     And ledger_item "l2" should not be matched
     And ledger_item "l3" should not be matched
     And I should see "Successfully updated ledger item."