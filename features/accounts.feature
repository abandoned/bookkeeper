Feature: Manage Accounts
  In order to take care of my accounting needs
  As a user
  I want to be able to create and manage accounts
  
  Background:
    Given I am logged in
    And I have a default ledger set up
  
  Scenario: Create an account
    Given I am on path "/accounts"
    When I follow "Create new account"
    And I fill in "Name" with "Current Assets"
    And I select "Assets" from "Parent"
    And I press "Submit"
    Then an account should exist with name: "Current Assets"
    And that account should be one of account "Assets"'s children
    And I should be on the show page for that account
  
  Scenario: Rename an existing account
    Given an account "Current Assets" exists with parent: account "Assets"
    And I am on the show page for account "Current Assets"
    When I follow "Edit"
    And I fill in "Name" with "Fixed Assets"
    And I press "Submit"
    Then I should see "Assets > Fixed Assets"
    And an account should exist with name: "Fixed Assets"
    And that account should be one of account "Assets"'s children
    
  Scenario: Do not have option to set parent of account to itself or its descendants
    Given an account "Current Assets" exists with name: "Current Assets", parent: account "Assets"
    And I am on the show page for account "Assets"
    When I follow "Edit"
    Then I should see "Liabilities" within "#account_parent_id"
    And I should not see "Assets" within "#account_parent_id"
    And I should not see "Current Assets" within "#account_parent_id"
  
  Scenario: Cannot create two accounts with identical names under the same parent
    Given an account "Current Assets" exists with name: "Current Assets", parent: account "Assets"
    And I am on path "/accounts"
    When I follow "Create new account"
    And I fill in "Name" with "Current Assets"
    And I select "Assets" from "parent"
    And I press "Submit"
    Then I should see "has already been taken"
  
  Scenario: Delete an account with no children
    Given an account "Current Assets" exists with parent: account "Assets"
    And I am on the show page for account "Current Assets"
    When I follow "Delete"
    Then I should see "Successfully deleted account"
    And account should not exist with name: "Current Assets"
  
  Scenario: Cannot delete an account that has children
    Given an account "Current Assets" exists with parent: account "Assets"
    And an account "Bank Account" exists with parent: account "Current Assets"
    And I am on the show page for account "Current Assets"
    When I follow "Delete"
    Then I should see "Cannot delete account because it has descendants"
    And account "Bank Account" should exist
    
  Scenario: Cannot delete an account that has transactions
    Given an account "Current Assets" exists with parent: account "Assets"
    And a ledger_item exists with account: account "Current Assets"
    And I am on the show page for account "Current Assets"
    When I follow "Delete"
    Then I should see "Cannot delete account because it has dependants"
    And account "Current Assets" should exist
  
  Scenario: Cannot delete a root account
    Given I am on the show page for account "Assets"
    When I follow "Delete"
    Then I should see "Cannot delete root account"
    And account "Assets" should exist
  
  Scenario: Create new child account from show page of an account
    Given I am on the show page for account "Assets"
    When I follow "New"
    And I fill in "Name" with "Current Assets"
    And I press "Submit"
    Then an account should exist with name: "Current Assets"
    And that account should be one of account "Assets"'s children
    And I should be on the show page for that account
    