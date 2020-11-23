Rails.application.routes.draw do
  resources :workout
  root 'workouts#index'
end
