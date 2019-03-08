Rails.application.routes.draw do
  resources :clicks
  resources :urls
  
  root 'urls#new'
end
