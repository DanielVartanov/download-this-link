Then /^I should see "(.*)"$/ do |text|
  webrat_session.response.body.to_s.should =~ /#{text}/m
end

Then /^I should see a link to "(.*)"$/ do |url|
  webrat_session.response.body.to_s.should have_tag("a", :href => url)
end

Then /^I should not see a link to "(.*)"$/ do |url|
  webrat_session.response.body.to_s.should_not have_tag("a", :href => url)
end

Then /^I should not see "(.*)"$/ do |text|
  webrat_session.response.body.to_s.should_not =~ /#{text}/m
end

Then /^the (.*) ?request should fail/ do |_|
  webrat_session.response.should_not be_successful
end

Then /^I should not be redirected$/ do
  webrat_session.response.should be_successful
end

Then /^I should be redirected to "(.*)"$/ do |url|
  URI.parse(webrat_session.response.url).path.should == url
end