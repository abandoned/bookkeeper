Feature: Manage People
  In order to keep the company in order
  As a user
  I want to be able to create and manage parties with whom I transact
  
  Background:
    Given I am logged in
    
  Scenario: Create a person
    Given I am on the path "/people/new"
    When I fill in "Name" with "Vendor"
    And I press "Submit"
    Then I should see "Successfully created person" within "#flash_notice"
    And I should see "Vendor" within "#main h1"
    And a person should exist with name: "Vendor"
  
  Scenario: Cannot delete a person who is the sender of a ledger item
    Given a person "Vendor" exists
    Given a ledger_item "Transaction" exists with sender: person "Vendor"
    When I am on the show page for person "Vendor"
    And I follow "Delete"
    Then I should see "Cannot delete person because she has dependants" within "#flash_error"
    And a person "Vendor" should exist
  
  Scenario: Cannot delete a person who is the recipient of a ledger item
    Given a person "Self" exists
    Given a ledger_item "Transaction" exists with recipient: person "Self"
    When I am on the show page for person "Self"
    And I follow "Delete"
    Then I should see "Cannot delete person because she has dependants" within "#flash_error"
    And a person "Self" should exist