Feature: Manage Ledger People
  In order to keep the company ledger in order
  As a bookkeeper
  I want to be able to create and manage vendors, customers, and other parties whom I transact with
  
  Background:
    Given I am logged in as bookkeeper
    
  Scenario: Create a person
    Given I am on the list of ledger people
    When I follow "New Ledger Person"
    And I fill in "Name" with "US Postal Service"
    And I press "Submit"
    Then I should see "Successfully created ledger person"
    And I should see "US Postal Service"