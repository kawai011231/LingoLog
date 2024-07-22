Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja/ do
    root to: 'diaries#show'

    get '/diaries', to: 'diaries#show'
    get '/diaries/index', to: 'diaries#index'
    get '/diaries/:date', to: 'diaries#show_or_new', as: 'diary_by_date'
    get '/diaries/:date/edit', to: 'diaries#edit', as: 'edit_diary_by_date'
    post '/diaries', to: 'diaries#create'
    patch '/diaries/:date', to: 'diaries#update', as: 'update_diary_by_date'

    resources :users
    get '/signup', to: 'users#new'
    resources :users do
      member do
        post 'toggle_writing_assist'
      end
    end
    
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'

    get '/question/generate_question', to: 'questions#generate_question'
  end
end
