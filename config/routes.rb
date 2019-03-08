Rails.application.routes.draw do
  resources :clicks
  resources :urls

  get "/:short_link" => "urls#show_by_short_link"
  
  root 'urls#new'
end
