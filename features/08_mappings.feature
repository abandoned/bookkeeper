Feature: Mappings
  In order to do bookkeeping
  As a bookkeeper
  I want to be able to define mappings for file imports
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in
  
  Scenario: Create a mapping
    Given I am on the path "/imports"
    When I follow "Import a new CSV file"
    And I follow "Create a new mapping"
    When I fill in "Name" with "Amex"
    And I fill in "Currency" with "GBP"
    And I fill in "Date row" with "1"
    And I fill in "Total amount row" with "3"
    And I fill in "Description row" with "4"
    And I check "Reverses sign"
    And I press "Create mapping"
    Then a mapping should exist