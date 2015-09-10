Volontariat.Survey.StoryApp.PageFormComponent = Ember.Component.extend
  computedPosition: (-> @get('position') + 1).property('position')
  computedName: (-> if @get('name') then @get('name') else Volontariat.t('survey_pages.show.untitled_page') ).property('name')
  computedText: (-> if @get('text') then @get('text') else Volontariat.t('survey_pages.show.page_without_text') ).property('text')
  editMode: (-> @get('selectedId') == @get('id')).property('selectedId', 'id')
  
  actions:
    
    enterEditMode: ->
      @sendAction 'editAction', @get('id')
      
    cancel: ->
      @sendAction 'editAction', null
    
    save: ->
      $.ajax(
        type: if @get('id') then 'PUT' else 'POST'
        url: '/api/v1/survey_pages' + if @get('id') then "/#{@get('id')}" else '', 
        data: { 
          survey_page: { story_id: Volontariat.Survey.StoryId, name: $('#page_name').val(), text: $('#page_text').val() } 
        }
      ).success((data) =>
        if data.errors
          alert "#{Volontariat.t('survey_pages.save.failed')}: #{JSON.stringify(data.errors)}"
        else
          @set 'id', data._id.$oid
          @sendAction 'reloadAction'
          @sendAction 'editAction', data._id.$oid
          alert Volontariat.t('survey_pages.save.successful')
      ).fail((data) =>
        alert "#{Volontariat.t('survey_pages.save.failed')}!"
      )
      
    destroy:  ->
      if confirm(Volontariat.t('survey_pages.destroy.confirmation'))
        $.ajax("/api/v1/survey_pages/#{@get('id')}?story_id=#{Volontariat.Survey.StoryId}", type: 'DELETE').done((data) =>
          @sendAction 'reloadAction'
        ).fail((data) ->
          alert Volontariat.t('activerecord.errors.models.survey_page.attributes.base.deletion_failed')
        ) 
    
    reload: ->
      @sendAction 'reloadAction'
      
    editPage: (id) ->
      @sendAction 'editAction', id
        
    addNewTask: ->
      @set 'newTask', true
      @set 'taskId', null
      
    editTask: (id) ->
      @set 'newTask', false
      @set 'taskId', id