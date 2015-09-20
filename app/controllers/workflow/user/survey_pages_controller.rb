class Workflow::User::SurveyPagesController < ApplicationController
  def show
    @story = Story.find(params[:story_id])
    @page = @story.pages.where(position: params[:page_position]).first
    @results = Product::Survey::Result.where(task_id: { '$in' => @page.tasks.map(&:id) }, user_id: current_user.id).index_by(&:task_id)
    @errors = {}
  end
  
  def update
    @story = Story.find(params[:story_id])
    @page = @story.pages.where(position: params[:page_position]).first
    tasks = {}
    tasks2 = Product::Survey::Task.where(id: { '$in' => @page.tasks.map(&:id) })
    tasks2.each {|task| tasks[task.id.to_s] = task }
    
    results = Product::Survey::Result.where(task_id: { '$in' => @page.tasks.map(&:id) }, user_id: current_user.id)
    @results = {}
    results.each{|result| @results[result.task_id.to_s] = result } 
    @errors = {}

    params[:results].each do |task_id, result_form|
      result = if result_form['id'].present? && @results[task_id].try(:user_id) == current_user.id
        @results[task_id]
      else
        value = Product::Survey::Result.new(task_id: task_id)
        value.user_id = current_user.id
        value
      end
      
      text = tasks[task_id].answer_type == 'Checkboxes' ? result_form['text'].to_json : result_form['text']
      
      result.update_attributes text: text
      
      unless result.valid?
        @errors[task_id] ||= []
        
        result.errors.full_messages.each {|message| @errors[task_id] << message }
      end
    end
    
    tasks.each do |task_id, task|
      next if params[:results].has_key? task_id
      
      @errors[task_id] ||= []
      @errors[task_id] << I18n.t('errors.messages.blank')
    end
    
    if @errors.empty?
      next_page_position = @story.pages.where(:position.gt => params[:page_position]).order_by(position: 'asc').first.try(:position)
     
      if next_page_position
        redirect_to survey_page_workflow_user_index_path(story_id: @story.slug, page_position: next_page_position)
      else
        @story.users_without_tasks_ids ||= []
        @story.users_without_tasks_ids << current_user.id
        @story.save
        
        flash[:notice] = I18n.t('surveys.complete.success_message')
        redirect_to workflow_user_index_path
      end
    else
      render 'show'
    end
  end
end