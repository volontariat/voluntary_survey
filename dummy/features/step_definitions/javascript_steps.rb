When /^I reload the page$/ do
  page.evaluate_script 'window.location.reload();'
end

When /^I confirm all future JS confirm dialogs on this page$/ do
  page.evaluate_script('window.confirm = function() { return true; }')
end

When /^I cancel all future JS confirm dialogs on this page$/ do
  page.evaluate_script('window.confirm = function() { return false; }')
end

When /^I confirm popup$/ do
  page.driver.browser.switch_to.alert.accept    
end

When /^I dismiss popup$/ do
  page.driver.browser.switch_to.alert.dismiss
end

Then /^I should see an alert telling me that "([^"]*)"$/ do |message|
  if Capybara.current_driver == :webkit
    expect(page.driver.alert_messages.last).to be == message
  else
    expect(page.driver.browser.switch_to.alert.text).to be == message
  end

  step %(I confirm the following alert)
end

When /^I confirm the following alert$/ do
  if Capybara.current_driver == :webkit
    page.driver.accept_js_confirms!
  else
    page.driver.browser.switch_to.alert.accept
  end
end