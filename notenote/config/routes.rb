Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'
  resources :notes
  
  authenticated :user do
    root 'notes#index', as: "autehnticated_root"
  end

  root 'welcome#index'
end
