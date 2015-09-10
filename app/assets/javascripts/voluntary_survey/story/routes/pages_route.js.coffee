Volontariat.Survey.StoryApp.PagesRoute = Ember.Route.extend
  model: (params) ->
    @controllerFor('pages').set 'newRecord', Volontariat.Survey.NewRecord
    @controllerFor('pages').set 'storyState', Volontariat.Survey.StoryState
    
    if Volontariat.Survey.NewRecord
      {}
    else
      Ember.$.getJSON("/api/v1/stories/#{Volontariat.Survey.StoryId}").then (json) =>
        @controllerFor('pages').set 'name', json.survey_story.name
        @controllerFor('pages').set 'text', json.survey_story.text

        @controllerFor('pages').set 'newPage', true if json.survey_story.pages.length == 0
        
        json.survey_story.pages = $.map json.survey_story.pages, (page, i) ->
          page.survey_page.tasks = $.map page.survey_page.tasks, (task, j) ->
            task.survey_task
            
          page.survey_page
          
        json.survey_story