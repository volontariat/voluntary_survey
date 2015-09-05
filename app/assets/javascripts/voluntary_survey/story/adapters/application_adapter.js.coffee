Volontariat.Survey.StoryApp.ApplicationAdapter = DS.RESTAdapter.extend
  namespace: 'api/v1',
  pathForType: (type) ->
    underscored = Ember.String.underscore(type)
    Ember.String.pluralize underscored