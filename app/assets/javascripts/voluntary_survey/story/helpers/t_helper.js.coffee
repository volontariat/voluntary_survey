Volontariat.Survey.StoryApp.THelper = Ember.Helper.helper((params) ->
  key = params[0]
  no_html = params[1]
  text = Volontariat.t key
  
  if text == undefined
    if no_html == true
      "Missing translation: #{key}"
    else
      new (Ember.Handlebars.SafeString)('<span class="translation_missing" title="translation missing: ' + Volontariat.locale + '.' + key + '">' + key + '</span>')
  else
    text
)