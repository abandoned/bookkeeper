Feature: Edit Transactions
  In order to take care of my accounting needs
  As a user
  I want to be able to edit transactions
  
  Background:
    Given I am logged in
      And I have a default ledger set up
  
  Scenario: Edit an unmatched ledger item
    Given an account exists with parent: account "Assets"
      And a ledger_item exists with account: that account
      And I am on the show page for that ledger_item
    When I follow "Edit"
      And I fill in "Total Amount" with "2"
      And I press "Submit"
    Then I should see "Successfully updated ledger item"