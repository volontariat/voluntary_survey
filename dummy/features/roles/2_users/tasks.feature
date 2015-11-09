@javascript
Feature: Manage tasks

  Scenario: Default
  
    Given a user named "user"
    And I log in as "user"
    And a survey project
    And I am on the new survey story page
    When I fill in "Name" with "Dummy"
    And I fill in "Text" with "Dummy"
    And I press "Create Story"
    And I press "Create Page"
    And I confirm the following alert
    And I click the new task button
    And I fill in "Question" with "Dummy"
    And I select "Drop-down list" from "Answer type"
    And I press "Create Task"
    And I fill in something in the first option field
    And I press "Create Option"
    And I press "Activate"
    And I am on the take survey story page
    And I press "Submit"
    Then I should see "Thanks for participating in the survey!"
    When I am on the story results page
    Then I should see "100 %"