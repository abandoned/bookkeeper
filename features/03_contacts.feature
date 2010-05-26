Feature: Manage Contacts
  In order to do bookkeeping
  As a user
  I want to be able to manage contacts
  
  Background:
    Given I am logged in
    
  Scenario: Create a contact
    Given I am on the path "/contacts/new"
    When I fill in "Name" with "Foo"
    And I press "Create contact"
    Then I should see "Successfully created contact"
    And a contact should exist with name: "Foo"
  
  Scenario: Delete a contact
    Given a contact exists
    When I am on path "/contacts"
    And I am on the show page for that contact
    And I follow "Delete contact"
    Then I should see "Successfully deleted contact"
    And that contact should not exist
    
  Scenario: Cannot delete a contact who is the sender of a ledger item
    Given a contact exists 
    And a ledger_item exists with sender: that contact
    And I am on the show page for that contact
    And I follow "Delete contact"
    Then I should see "Cannot delete contact because she has dependants"
    And that contact should exist
  
  Scenario: Cannot delete a contact who is the recipient of a ledger item
    Given a contact exists
    Given a ledger_item exists with recipient: that contact
    And I am on the show page for that contact
    And I follow "Delete contact"
    Then I should see "Cannot delete contact because she has dependants"
    And that contact should exist