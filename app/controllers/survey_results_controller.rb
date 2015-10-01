class SurveyResultsController < ApplicationController
  def index
    @story = Story.find(params[:story_id])
    @project = @story.project
    @results = {}
    @hide_sidebar = true
    
    @story.pages.each do |page|
      page.tasks.where(answer_type: { '$in' => ['Short text', 'Long text'] }).each do |task|
        @results[task.id.to_s] = task.results.paginate(page: params["result_#{task.id}_page".to_sym], per_page: 10)
      end
    end
  end
end