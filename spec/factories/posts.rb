# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    user

    title { 'Post title' }
    body { 'Post body' }
    ip { '166.241.154.121' }
  end
end
