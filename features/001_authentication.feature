Feature: Authentication
  In order to keep the company books in order
  As a bookkeeper
  I want to authenticate myself
  
  Scenario: Log in
    Given the following user record:
      | login      | password |
      | bookkeeper | secret   |
    And I am on the login page
    When I fill in "Username" with "bookkeeper"
    And I fill in "Password" with "secret"
    And I press "Log in"
    Then I should see "Log out"
    
  Scenario: Require login on list of accounts
    When I go to the list of accounts
    Then I should be on the login page
    
  Scenario: Require login on list of people
    When I go to the list of people
    Then I should be on the login page
  
  Scenario: Require login on list of transactions
    When I go to the list of transactions
    Then I should be on the login page
  
  Scenario: Require login on list of mappings
    When I go to the list of mappings
    Then I should be on the login page