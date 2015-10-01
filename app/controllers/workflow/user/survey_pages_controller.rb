class Workflow::User::SurveyPagesController < ApplicationController
  def show
    @story = Story.find(params[:story_id])
    @page = @story.pages.where(position: params[:page_position]).first
    @results = Product::Survey::Result.where(task_id: { '$in' => @page.tasks.map(&:id) }, user_id: current_user.id).index_by{|r| r.task_id.to_s}
    @errors = {}
  end
  
  def update
    @story = Story.find(params[:story_id])
    @page = @story.pages.where(position: params[:page_position]).first
    @results, @errors = @page.set_results(params[:results], current_user)
    
    if @errors.empty?
      next_page_position = @story.submit_page(params[:page_position], current_user)
      
      if next_page_position
        redirect_to survey_page_workflow_user_index_path(story_id: @story.slug, page_position: next_page_position)
      else
        flash[:notice] = I18n.t('surveys.complete.success_message')
        redirect_to workflow_user_index_path
      end
    else
      render 'show'
    end
  end
end