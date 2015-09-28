class SurveyResultsController < ApplicationController
  def index
    @story = Story.find(params[:story_id])
    @project = @story.project
    @twitter_sidenav_level = 5
  end
end