Volontariat.Survey.StoryApp.TaskOptionFormComponent = Ember.Component.extend
  keyInputId: (-> "input_option_key_#{@get('id')}").property('id')
  valueInputId: (-> "input_option_value_#{@get('id')}").property('id')
  keyPlaceholder: (-> Volontariat.t('activerecord.attributes.survey_input_option.key')).property('answerType')  
  valuePlaceholder: (-> Volontariat.t('activerecord.attributes.survey_input_option.value')).property('answerType')  
            
  actions:
    
    save: ->
      $.ajax(
        type: if @get('id') then 'PUT' else 'POST'
        url: '/api/v1/survey_input_options' + if @get('id') then "/#{@get('id')}" else '', 
        data: { 
          survey_input_option: { 
            story_id: Volontariat.Survey.StoryId, page_id: @get('pageId'),
            task_id: @get('taskId'), key: $("##{@get('keyInputId')}").val(), 
            value: $("##{@get('valueInputId')}").val() 
          } 
        }
      ).success((data) =>
        if data.errors
          alert "#{Volontariat.t('survey_input_options.save.failed')}: #{JSON.stringify(data.errors)}"
        else
          unless @get('id')
            @sendAction 'addOptionAction', { id: data._id, key: data.key, value: data.value }
            
            $("##{@get('keyInputId')}").val('')
            $("##{@get('valueInputId')}").val('')
            
          #@sendAction 'reloadAction'
          #@sendAction 'editPageAction', @get('pageId')
          #@sendAction 'editTaskAction', @get('taskId')
      ).fail((data) =>
        alert "#{Volontariat.t('survey_input_options.save.failed')}!"
      )
      
    destroy:  ->
      $.ajax("/api/v1/survey_input_options/#{@get('id')}?story_id=#{Volontariat.Survey.StoryId}&page_id=#{@get('pageId')}&task_id=#{@get('taskId')}", type: 'DELETE').done((data) =>
        #@sendAction 'reloadAction'
        @set 'deleted', true
      ).fail((data) ->
        alert Volontariat.t('activerecord.errors.models.survey_input_option.attributes.base.deletion_failed')
      ) 