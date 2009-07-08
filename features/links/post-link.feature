Feature: Posting a link
  In order to let users tell application which files to download
  Users should have opportunity to post new links

  Scenario: User sees a link to new link page on the main page
    When I go to main page
    Then I should see a link to "/links/new"

  Scenario: User sees a new link form
    When I go to new link page
    Then I should see "link_url"
    And I should see "Добавить ссылку"

  Scenario: User posts valid link
    When I go to new link page
    And I fill in "link_url" with "http://example.com"
    And I press "Добавить ссылку"
    Then I should be redirected to links list
    And I should see a link to "http://example.com"
    And I should see "В очереди"

  Scenario: User tries to post invalid link
    When I go to new link page
    And I fill in "link_url" with "bla-bla-bla"
    And I press "Добавить ссылку"
    Then I should not be redirected
    And I should see "Неверный URL!"
    And I should not see a link to "bla-bla-bla"
    And I should not see "В очереди"

  Scenario: User tries to post blank link
    When I go to new link page
    And I fill in "link_url" with ""
    And I press "Добавить ссылку"
    Then I should not be redirected
    And I should see "Неверный URL!"
    And I should not see a link to ""
    And I should not see "В очереди"

  Scenario: User posts an FTP link
    When I go to new link page
    And I fill in "link_url" with "ftp://example.com"
    And I press "Добавить ссылку"
    Then I should be redirected to links list
    And I should see a link to "ftp://example.com"
    And I should see "В очереди"

  Scenario: User tries to post well formed link with some other protocol
    When I go to new link page
    And I fill in "link_url" with "svn://example.com"
    And I press "Добавить ссылку"
    And I should see "Неверный URL!"
    And I should not see a link to "svn://example.com"
    And I should not see "В очереди"