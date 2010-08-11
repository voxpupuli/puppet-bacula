Feature: forge.puppetlabs.com
  It should be up
  And I should be able to search for modules

  Scenario: Searching for modules
    When I go to http://forge.puppetlabs.com
    And I fill in "q" with "puppetlabs"
    And I press "Go"
    Then I should see "Search for modules matching"
