Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  resources :tasks
  root 'home#index'
end
