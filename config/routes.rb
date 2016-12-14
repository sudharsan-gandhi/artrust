Rails.application.routes.draw do
  
  root 'posts#index'
  resources :posts do
  	member do
  		put "like", to: "posts#upvote"
  		put "dislike", to: "posts#downvote"
  		post "comments", to: "posts#comments"
  	end
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
