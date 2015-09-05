Volontariat.Survey.StoryApp.PagesController = Ember.Controller.extend
  actions:
    
    saveStory: ->
      $.ajax(
        type: if Volontariat.Survey.NewRecord then 'POST' else 'PUT'
        url: '/api/v1/stories' + if Volontariat.Survey.NewRecord then '' else "/#{Volontariat.Survey.StoryId}", 
        data: { 
          story: { project_id: Volontariat.Survey.ProjectId, name: $('#story_name').val(), text: $('#story_text').val() } 
        }
      ).success((data) =>
        if data.errors
          Volontariat.alert 'danger', "#{Volontariat.t('stories.save.failed')}: #{JSON.stringify(data.errors)}"
        else
          Volontariat.Survey.NewRecord = false
          @set 'newRecord', false
          Volontariat.Survey.StoryId = data.id
          @transitionToRoute 'no_data'
          @transitionToRoute 'pages'
          Volontariat.alert 'success', Volontariat.t('stories.save.successful')
      ).fail((data) =>
        Volontariat.alert 'danger', "#{Volontariat.t('stories.save.failed')}!"
      )