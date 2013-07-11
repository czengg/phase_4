Karate67272::Application.routes.draw do

  resources :users


  resources :dojo_students


  resources :dogos


  resources :tournaments


  # Generated routes
  resources :events
  resources :registrations
  resources :sections
  resources :students
  
  # Semi-static page routes
  match 'home' => 'home#index', :as => :home
  match 'about' => 'home#about', :as => :about
  match 'contact' => 'home#contact', :as => :contact
  match 'privacy' => 'home#privacy', :as => :privacy
  match 'search' => 'home#search', :as => :search

  # Set the root url
  root :to => 'home#index'
  
end

