Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :comments, only: [:index, :create]

      namespace :articles do
        resources :drafts, only: [:index, :show]
      end

      resources :articles do
        collection do
          get "search"
        end
      end

      resources :article_likes, only: [:create, :destroy]

      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }
      namespace :current do
        resources :articles, only: [:index]
      end
    end
  end
end
