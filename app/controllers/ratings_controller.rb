# frozen_string_literal: true

class RatingsController < ApplicationController
  def create
    form = RatingForm.new(attributes: rating_params)

    if form.save
      render json: RatingSerializer.new(form.record).as_json, status: :created
    else
      render json: { errors: form.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def rating_params
    params.slice(:post_id, :user_id, :value).permit!
  end
end
