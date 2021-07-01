Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }
      resources :comments, only: [:create]

      namespace :articles do
        resources :drafts, only: [:index, :show]
      end

      namespace :current do
        resources :articles, only: [:index]
      end
      resources :articles
    end
  end
end
