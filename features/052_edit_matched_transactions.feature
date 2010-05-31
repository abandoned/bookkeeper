Feature: Edit Matched Transactions
  In order to do bookkeeping
  As a user
  I want to be able to edit matched transactions

  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in

Scenario: Editing a matched transaction's contacts should update the matched transaction's contacts as well
  Given I have a double entry for a flour purchase from Flour Corp
  And I am on the path "/transactions/1/edit"
  When I select "Awesome Bakery" from "Sender"
  And select "Flour Corp" from "Recipient"
  And I fill in "Total amount" with "-999"
  And press "Update transaction"
  Then a ledger_item should exist with sender: contact "Awesome Bakery", recipient: contact "Flour Corp", total_amount: -999
