When /^I click the new task button$/ do
  find(:xpath, '(//button[@class="new_task_button"])[1]').click
end

When /^I fill in something in the first option field$/ do
  find(:xpath, ".//*[@name='survey_input_option[value]']").set('Dummy')
end