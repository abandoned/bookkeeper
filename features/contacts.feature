Feature: Manage Contacts
  In order to do proper accounting
  As a user
  I want to be able to create and manage parties with whom I transact
  
  Background:
    Given I am logged in
    
  Scenario: Create a contact
    Given I am on the path "/contacts/new"
    When I fill in "Name" with "Vendor"
    And I press "Submit"
    Then I should see "Successfully created contact" within "#flash_notice"
    And I should see "Vendor" within "#main h1"
    And a contact should exist with name: "Vendor"
  
  Scenario: Cannot delete a contact who is the sender of a ledger item
    Given a contact "Vendor" exists 
    Given a ledger_item "Transaction" exists with sender: contact "Vendor"
    When I am on the show page for contact "Vendor"
    And I follow "Delete"
    Then I should see "Cannot delete contact because she has dependants" within "#flash_failure"
    And a contact "Vendor" should exist
  
  Scenario: Cannot delete a contact who is the recipient of a ledger item
    Given a contact "Self" exists
    Given a ledger_item "Transaction" exists with recipient: contact "Self"
    When I am on the show page for contact "Self"
    And I follow "Delete"
    Then I should see "Cannot delete contact because she has dependants" within "#flash_failure"
    And a contact "Self" should exist