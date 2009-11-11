Feature: Manage Accounts
  In order to keep the company in order
  As a bookkeeper
  I want to be able to create and manage accounts
  
  Background:
    Given I have a default ledger set up
    And I am logged in as bookkeeper
  
  Scenario: Create an account
    Given I am on the list of accounts
    When I follow "New Account"
    And I fill in "Name" with "Current Assets"
    And I select "Assets" from "Parent*"
    And I press "Submit"
    Then I should see "Successfully created account"
    And I should see "Assets > Current Assets"
    
  Scenario: Rename an existing account
    Given I have a Current Assets account descending from Assets
    And I am on the Current Assets account page
    When I follow "Edit"
    And I fill in "Name" with "Fixed Assets"
    And I press "Submit"
    Then I should see "Assets > Fixed Assets"
  
  Scenario: Cannot create an account without a parent
  
  Scenario: Do not have option to set parent of account to itself or its descendants
    Given I have a Current Assets account descending from Assets
    And I am on the Assets account page
    When I follow "Edit"
    Then the "Parent" select list should have option "Liabilities"
    And the "Parent" select list should not have option "Assets"
    And the "Parent" select list should not have option "Current Assets"
  
  Scenario: Cannot create two accounts with identical names under the same parent
    Given I have a Current Assets account descending from Assets
    And I am on the list of accounts
    When I follow "New Account"
    And I fill in "Name" with "Current Assets"
    And I select "Assets" from "parent"
    And I press "Submit"
    Then I should see "has already been taken"
    
  Scenario: Destroy an account with no children
    Given I have a Current Assets account descending from Assets
    And I am on the Current Assets account page
    When I follow "Destroy"
    Then I should see "Successfully deleted account"
    
  Scenario: Cannot destroy an account that has children