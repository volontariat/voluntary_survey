class SurveyTaskSerializer < TaskSerializer
  attributes :position, :answer_type, :options
  
  def options
    object.options.order_by(position: 'asc').map{|o| SurveyInputOptionSerializer.new(o)}
  end
end