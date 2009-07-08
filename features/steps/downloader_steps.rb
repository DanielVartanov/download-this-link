Given /^Link "(.*)" is downloaded$/ do |url|
  Given %{Link "#{url}" has status "downloaded"}  
end

Given /^Link "(.*)" is queued$/ do |url|
  Given %{Link "#{url}" has status "queued"}
end

Given /^Link "(.*)" is failure$/ do |url|
  Given %{Link "#{url}" has status "failure"}
end

Given /^Link "(.*)" is downloading$/ do |url|
  Given %{Link "#{url}" has status "downloading"}
end

Given /^Link "(.*)" has status "(.*)"$/ do |url, status|
  link = Link.find_by_url(url)
  link.update_attribute(:status, status)
end

Given /^Link "(.*)" has file "(.*)"$/ do |url, filename|
  link = Link.find_by_url(url)
  link.update_attribute(:file_path, filename)
end