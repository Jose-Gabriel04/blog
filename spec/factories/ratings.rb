# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    post
    user

    value { 5 }
  end
end
