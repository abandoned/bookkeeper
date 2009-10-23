Feature: Manage Ledger Accounts
  In order to keep the company ledger in order
  As a bookkeeper
  I want to be able to create and manage accounts
  
  Background:
    Given I have a default ledger set up
    And I am logged in as bookkeeper
  
  Scenario: Create an account
    Given I am on the list of ledger accounts
    When I follow "New Ledger Account"
    And I fill in "Name" with "Current Assets"
    And I select "Assets" from "Parent*"
    And I press "Submit"
    Then I should see "Successfully created ledger account"
    And I should see "Assets > Current Assets"
    
  Scenario: Rename an existing account
    Given I have a Current Assets ledger account descending from Assets
    And I am on the Current Assets ledger account page
    When I follow "Edit"
    And I fill in "Name" with "Fixed Assets"
    And I press "Submit"
    Then I should see "Assets > Fixed Assets"
  
  Scenario: Do not have option to set parent of account to itself or its descendants
    Given I have a Current Assets ledger account descending from Assets
    And I am on the Assets ledger account page
    When I follow "Edit"
    Then the "Parent" select list should have option "Liabilities"
    And the "Parent" select list should not have option "Assets"
    And the "Parent" select list should not have option "Current Assets"
  
  Scenario: Cannot create an account with no parent set
    Given I am on the list of ledger accounts
    When I follow "New Ledger Account"
    And I fill in "Name" with "Impossible ledger account"
    And I press "Submit"
    Then I should see "1 error prohibited this ledger account from being saved"
    And I should see "Parent does not exist"
  
  Scenario: Cannot create two accounts with identical names under the same parent
    Given I have a Current Assets ledger account descending from Assets
    And I am on the list of ledger accounts
    When I follow "New Ledger Account"
    And I fill in "Name" with "Current Assets"
    And I select "Assets" from "parent"
    And I press "Submit"
    Then I should see "1 error prohibited this ledger account from being saved"
    And I should see "Name has already been taken"
    
  Scenario: Destroy an account with no children
    Given I have a Current Assets ledger account descending from Assets
    And I am on the Current Assets ledger account page
    When I follow "Destroy"
    Then I should see "Successfully deleted ledger account"
    
  Scenario: Cannot destroy an account that has children
    Given I have a Current Assets ledger account descending from Assets
    And I am on the Assets ledger account page
    When I follow "Destroy"
    Then I should see "Ledger account may not be deleted"
    And I should see "Assets"