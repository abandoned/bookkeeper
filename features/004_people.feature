Feature: Manage People
  In order to keep the company in order
  As a bookkeeper
  I want to be able to create and manage vendors, customers, and other parties whom I transact with
  
  Background:
    Given I am logged in as bookkeeper
    
  Scenario: Create a person
    Given I am on the list of people
    When I follow "New Person"
    And I fill in "Name" with "US Postal Service"
    And I press "Submit"
    Then I should see "Successfully created person"
    And I should see "US Postal Service"