class SurveyStorySerializer < StorySerializer
  attributes :pages
  
  def pages
    object.pages.order_by(position: 'asc').map{|a| SurveyPageSerializer.new(a)}
  end
end