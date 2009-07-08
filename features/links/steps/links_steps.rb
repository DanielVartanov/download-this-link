Given /^I post link "(.*)"$/ do |url|
  When %{I go to new link page}
  And %{I fill in "link_url" with "#{url}"}
  And %{I press "Добавить ссылку"}
  Then %{I should be redirected to links list}
  And %{I should see a link to "#{url}"}  
end

When /^I go to main page$/ do
  When %{I go to "/links"}
end

When /^I go to new link page$/ do
  When %{I go to "/links/new"}
end

Then /I should be redirected to links list/ do
  Then %{I should be redirected to "/links"}
end