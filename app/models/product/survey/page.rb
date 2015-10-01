class Product::Survey::Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::MassAssignmentSecurity
  include Mongoid::Orderable
  
  embedded_in :story, class_name: 'Product::Survey::Story', inverse_of: :pages
  has_many :tasks, class_name: 'Product::Survey::Task', inverse_of: :page
  
  field :name, type: String
  field :text, type: String
  
  orderable
  
  attr_accessible :story_id, :position, :name, :text
  
  def set_results(params, user)
    working_tasks = tasks.index_by{|t| t.id.to_s }
    results = Product::Survey::Result.where(task_id: { '$in' => tasks.map(&:id) }, user_id: user.id).index_by{|r| r.task_id.to_s }
    errors = {}
    
    params.each do |task_id, result_form|
      result = if result_form['id'].present? && results[task_id].try(:user_id) == user.id
        results[task_id]
      else
        value = Product::Survey::Result.new(task_id: task_id)
        value.user_id = user.id
        value
      end
      
      text = working_tasks[task_id].answer_type == 'Checkboxes' ? result_form['text'].to_json : result_form['text']
      
      result.update_attributes text: text
      
      results[result.task_id.to_s] = result
      
      unless result.valid?
        errors[task_id] ||= []
        
        result.errors.full_messages.each {|message| errors[task_id] << message }
      end
    end
    
    working_tasks.each do |task_id, task|
      next if params.has_key? task_id
      
      errors[task_id] ||= []
      errors[task_id] << I18n.t('errors.messages.blank')
    end
    
    [results, errors]
  end
  
  protected
  
  def with_offeror; false; end
end