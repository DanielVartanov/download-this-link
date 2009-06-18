Feature: List of posted links
  1) Newcomers should see some activity on the site
  2) People who posted several links should see their status
  3) User who wants to find some link should see the list of the links
  Therefore we are to implement index of posted links.

  Background:
    Given I post link "http://movies.com/the-matrix.mov"
    And I post link "http://sun.com/net-beans-6.7.sh"

  Scenario: User should see the list of links on the main page
    When I go to main page
    Then I should see "http://movies.com/the-matrix.mov"
    And I should see "http://sun.com/net-beans-6.7.sh"