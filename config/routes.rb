Rails.application.routes.draw do
  namespace :voluntary, path: 'api', module: 'voluntary/api', defaults: {format: 'json'} do
    namespace :v1 do
      resources :survey_pages, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
