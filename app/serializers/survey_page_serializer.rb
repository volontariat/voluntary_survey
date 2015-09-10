class SurveyPageSerializer < ActiveModel::Serializer
  attributes :id, :name, :text, :tasks
  
  def tasks
    object.tasks.order_by(position: 'asc').map{|a| SurveyTaskSerializer.new(a)}
  end
end