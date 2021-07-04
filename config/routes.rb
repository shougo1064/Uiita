Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :articles do
        collection do
          get "search"
        end
        resources :drafts, only: [:index, :show]
      end

      resources :article_likes, only: [:create, :destroy]

      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }
      resources :comments, only: [:create]

      namespace :current do
        resources :articles, only: [:index]
      end
    end
  end
end
