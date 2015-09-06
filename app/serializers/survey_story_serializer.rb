class SurveyStorySerializer < StorySerializer
  attributes :pages
  
  def pages
    object.pages.map{|a| SurveyPageSerializer.new(a)}
  end
end