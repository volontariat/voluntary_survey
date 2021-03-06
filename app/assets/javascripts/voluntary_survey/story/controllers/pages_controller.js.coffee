Volontariat.Survey.StoryApp.PagesController = Ember.Controller.extend
  canActivateStory: (-> @get('storyState') == 'new' || @get('storyState') == 'tasks_defined').property('storyState')

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
          if Volontariat.Survey.NewRecord
            @set 'newPage', true
            Volontariat.Survey.NewRecord = false
            @set 'newRecord', false
          
          Volontariat.Survey.StoryId = data.survey_story.id.$oid
          @transitionToRoute 'no_data'
          @transitionToRoute 'pages'
          Volontariat.alert 'success', Volontariat.t('stories.save.successful')
      ).fail((data) =>
        Volontariat.alert 'danger', "#{Volontariat.t('stories.save.failed')}!"
      )
      
    addNewPage: ->
      @set 'newPage', true
      @set 'pageId', null
      
    editPage: (id) ->
      @set 'newPage', false
      @set 'pageId', id
    
    triggerStoryEvent: (event) ->
      $.ajax(
        type: 'PUT'
        url: "/api/v1/stories/#{Volontariat.Survey.StoryId}/#{event}"
      ).success((data) =>
        if data.errors
          Volontariat.alert 'danger', "#{Volontariat.t('stories.save.failed')}: #{JSON.stringify(data.errors)}"
        else
          @set 'storyState', data.survey_story.state
          Volontariat.alert 'success', Volontariat.t('stories.save.successful')
      ).fail((data) =>
        Volontariat.alert 'danger', "#{Volontariat.t('stories.save.failed')}!"
      )
      
    reload: ->
      @transitionToRoute 'no_data'
      @transitionToRoute 'pages'