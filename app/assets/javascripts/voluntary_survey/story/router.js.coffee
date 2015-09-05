Volontariat.Survey.StoryApp.Router.reopen location: 'hash'

Volontariat.Survey.StoryApp.Router.map ->
  @_super
  
  @resource 'pages'
  
  @route 'no_data'