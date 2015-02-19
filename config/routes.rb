Rails.application.routes.draw do

  root 'static_pages#home'
  
  devise_for :users
  
  resources :quizzes do 
    put 'toggle_publish' => 'publish_quizzes#create'
  end

  resources :quiz_events
  resources :questions do
    post 'copy' => 'copy_questions#create'
  end
  delete 'clear_quiz_events_history', to: 'quiz_events#clear'

  resource :quiz_merges, only: [:new, :create]
  
  match '/search',  to: 'search#index',         via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  resources :cheatsheets
  get 'cheatsheet_tags/:tag', to: 'cheatsheets#index', as: :cheatsheet_tag

  resources :decks
  get 'deck_tags/:tag', to: 'decks#index', as: :deck_tag

  resources :flash_cards

  resources :deck_events, only: [:new, :create, :destroy, :index]
  delete 'clear_deck_events_history', to: 'deck_events#clear'
end
