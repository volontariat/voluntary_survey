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
    @errors = {}
    
    params[:results].each do |task_id, result_form|
      result = if result_form['id'].present?
        Product::Survey::Result.find result_form.delete('id')
      else
        nil
      end
      
      unless result.try(:user_id) == current_user.id
        result = Product::Survey::Result.new(task_id: task_id)
        result.user_id = current_user.id
      end
      
      result.update_attributes result_form
      
      unless result.valid?
        @errors[task_id] ||= []
        
        result.errors.full_messages.each {|message| @errors[task_id] << message }
      end
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