Given /^I am logged in as bookkeeper$/ do
  Given "the following user records", table(%{
    | login      | password |
    | bookkeeper | secret   |
  })
  And "I am on the login page"
  And 'I fill in "Username" with "bookkeeper"'
  And 'I fill in "Password" with "secret"'
  And 'I press "Log in"'
end
  