Feature: Authentication
  In order to take care of my accounting needs
  As a user
  I want to authenticate myself
  
  Scenario: Log in
    Given a user: "bookkeeper" exists with login: "bookkeeper", password: "secret"
    When I go to path "/user_session/new"
    And I fill in "Username" with "bookkeeper"
    And I fill in "Password" with "secret"
    And I press "Log in"
    Then I should see "You are logged in"
  
  Scenario: Fail to log in
    Given a user: "bookkeeper" exists with login: "bookkeeper", password: "secret"
    When I go to path "/user_session/new"
    And I fill in "Username" with "bookkeeper"
    And I fill in "Password" with "wrong"
    And I press "Log in"
    Then I should see "Username or password is incorrect"
  
  Scenario Outline: Require login to view various resources
    When I go to path "<path>"
    Then I should be on path "/user_session/new"
  
  Examples:
      | path              |
      | /accounts         |
      | /contacts         |
      | /transactions     |
      | /mappings         |
      | /accounts/1/rules |
