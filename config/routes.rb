# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts, only: [:create] do
    resources :ratings, only: [:create]

    collection do
      get :top
      get :shared_ips
    end
  end
end
