Volontariat.Survey.StoryApp.TaskFormComponent = Ember.Component.extend
  computedPosition: (-> @get('position') + 1).property('position')
  editMode: (-> @get('selectedId') == @get('id')).property('selectedId', 'id')
  answerTypes: ['Multiple choice', 'Checkboxes', 'Drop-down list', 'Short text', 'Long text']
  shortTextAnswer: (-> @get('answerType') == 'Short text').property('answerType')
  longTextAnswer: (-> @get('answerType') == 'Long text').property('answerType')
  answerWithOptions: (-> @get('answerType') == 'Multiple choice' || @get('answerType') == 'Checkboxes' || @get('answerType') == 'Drop-down list').property('answerType')
  multipleChoiceAnswer: (-> @get('answerType') == 'Multiple choice').property('answerType')
  checkboxesAnswer: (-> @get('answerType') == 'Checkboxes').property('answerType')
  dropDownAnswer: (-> @get('answerType') == 'Drop-down list').property('answerType')
  
  actions:
    
    enterEditMode: ->
      @sendAction 'editAction', @get('id')
      
    cancel: ->
      @sendAction 'editAction', null
    
    changeAnswerType: ->
      @set 'answerType', $('#task_answer_type').val()
    
    addOption: (option) ->
      options = @get('options')
      options.pushObject option
      @set 'options', options

    save: ->
      $.ajax(
        type: if @get('id') then 'PUT' else 'POST'
        url: '/api/v1/survey_tasks' + if @get('id') then "/#{@get('id')}" else '', 
        data: { 
          survey_task: { 
            story_id: Volontariat.Survey.StoryId, page_id: @get('pageId'), name: $('#task_name').val(), 
            answer_type: $('#task_answer_type').val()
            text: $('#task_text').val() 
          } 
        }
      ).success((data) =>
        if data.errors
          alert "#{Volontariat.t('survey_tasks.save.failed')}: #{JSON.stringify(data.errors)}"
        else
          @set 'id', data.task.id.$oid
          @sendAction 'reloadAction'
          @sendAction 'editPageAction', @get('pageId')
          @sendAction 'editAction', data.task.id.$oid
          alert Volontariat.t('survey_tasks.save.successful')
      ).fail((data) =>
        alert "#{Volontariat.t('survey_tasks.save.failed')}!"
      )
      
    destroy:  ->
      if confirm(Volontariat.t('survey_tasks.destroy.confirmation'))
        $.ajax("/api/v1/survey_tasks/#{@get('id')}?story_id=#{Volontariat.Survey.StoryId}&page_id=#{@get('pageId')}", type: 'DELETE').done((data) =>
          @sendAction 'reloadAction'
        ).fail((data) ->
          alert Volontariat.t('activerecord.errors.models.survey_task.attributes.base.deletion_failed')
        ) 