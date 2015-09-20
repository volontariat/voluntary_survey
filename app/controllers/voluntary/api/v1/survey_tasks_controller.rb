class Voluntary::Api::V1::SurveyTasksController < ActionController::Base
  include Voluntary::V1::BaseController
  
  respond_to :json
  
  def show
    resource = Product::Survey::Story.find(params[:story_id]).pages.find(params[:page_id]).tasks.find(params[:id])
      
    respond_to do |format|
      format.json do
        render json: resource
      end
    end
  end
  
  def create
    story = Product::Survey::Story.find params[:survey_task][:story_id]
    
    authorize! :update, story
    
    resource = story.pages.find(params[:survey_task].delete(:page_id)).tasks.create params[:survey_task]
    
    respond_to do |format|
      format.json do
        render json: resource.persisted? ? SurveyTaskSerializer.new(resource) : { errors: resource.errors.to_hash }
      end
    end
  end
  
  def update
    story = Product::Survey::Story.find params[:survey_task].delete(:story_id)
    
    authorize! :update, story
    
    resource = story.pages.find(params[:survey_task].delete(:page_id)).tasks.find(params[:id])
    resource.update_attributes params[:survey_task]

    respond_to do |format|
      format.json do
        render json: resource.valid? ? resource : { errors: resource.errors.to_hash }
      end
    end
  end
  
  def destroy
    story = Product::Survey::Story.find(params[:story_id])
    
    authorize! :destroy, story
    
    resource = story.pages.find(params[:page_id]).tasks.find(params[:id])
    resource.destroy
    
    respond_to do |format|
      format.json do
        render json: if resource.persisted?
          { error: I18n.t('activerecord.errors.models.survey_page.attributes.base.deletion_failed') }
        else
          {}
        end
      end
    end
  end
end