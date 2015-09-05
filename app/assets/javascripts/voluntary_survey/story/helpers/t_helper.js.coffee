Ember.Handlebars.helper 't', (key, no_html, options) ->
  text = Volontariat.t key
  
  if text == undefined
    if no_html == true
      "Missing translation: #{key}"
    else
      new (Ember.Handlebars.SafeString)('<span class="translation_missing" title="translation missing: ' + Volontariat.locale + '.' + key + '">' + key + '</span>')
  else
    text