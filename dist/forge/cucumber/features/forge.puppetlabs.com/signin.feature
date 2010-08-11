Feature: forge.puppetlabs.com
  It should be up
  And I should be able to get to the sign on page

  Scenario: Sign In
    When I go to http://forge.puppetlabs.com
    And I follow "Sign In"
    Then I should see "Sign in"

