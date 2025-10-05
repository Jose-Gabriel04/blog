# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts, only: [:create] do
    collection do
      get :top
      get :shared_ips
    end
  end

  resources :ratings, only: [:create]
end
