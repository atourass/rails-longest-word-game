Rails.application.routes.draw do
  get '/ask', to: 'games#ask'

  get '/result', to: 'games#result'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

