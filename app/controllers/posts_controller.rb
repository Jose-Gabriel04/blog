# frozen_string_literal: true

class PostsController < ApplicationController
  def create
    form = PostForm.new(attributes: post_params)

    if form.save
      render json: PostSerializer.new(form.record).as_json, status: :created
    else
      render json: { errors: form.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.slice(:title, :body, :user_login, :ip).permit!
  end
end
