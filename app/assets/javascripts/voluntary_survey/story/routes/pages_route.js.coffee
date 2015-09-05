Volontariat.Survey.StoryApp.PagesRoute = Ember.Route.extend
  model: (params) ->
    @controllerFor('pages').set 'newRecord', Volontariat.Survey.NewRecord
    
    if Volontariat.Survey.NewRecord
      []
    else
      Ember.$.getJSON("/api/v1/stories/#{Volontariat.Survey.StoryId}").then (json) =>
        @controllerFor('pages').set 'name', json.name
        @controllerFor('pages').set 'text', json.text
        
      @store.query 'survey_page', story_id: Volontariat.Survey.StoryId
