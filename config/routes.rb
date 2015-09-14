Rails.application.routes.draw do
  namespace 'workflow' do
    resources :user, only: :index do
      collection do
        get 'stories/:story_id/pages/:page_position' => 'user/survey_pages#show', as: :survey_page
        put 'stories/:story_id/pages/:page_position' => 'user/survey_pages#update'
      end
    end
  end
  
  namespace :voluntary, path: 'api', module: 'voluntary/api', defaults: {format: 'json'} do
    namespace :v1 do
      resources :survey_pages, only: [:create, :show, :update, :destroy]
      resources :survey_tasks, only: [:create, :show, :update, :destroy]
    end
  end
end
