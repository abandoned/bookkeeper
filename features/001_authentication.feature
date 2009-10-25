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
    Then I should be on the home page
    And I should see "Log out"
    
  Scenario: Redirect to login when not logged in
    When I go to the list of ledger accounts
    Then I should be on the login page