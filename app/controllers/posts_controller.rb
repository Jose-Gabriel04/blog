# frozen_string_literal: true

class PostsController < ActionController::API
  wrap_parameters false

  def create
    form = PostForm.new(attributes: post_params)

    if form.save
      render json: PostSerializer.new(form.record, context: :post).as_json, status: :created
    else
      render json: { errors: form.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def top
    top_rating_posts = TopPostsQuery.new(top_posts_params).call

    render json: top_rating_posts.map { |p| PostSerializer.new(p, context: :top).as_json }
  end

  def shared_ips
    shared_ips = SharedIpsQuery.new.call

    render json: shared_ips.map { |s| PostSerializer.new(s, context: :shared_ips).as_json }
  end

  private

  def post_params
    params.slice(:title, :body, :user_login, :ip).permit!
  end

  def top_posts_params
    params.slice(:limit).permit!
  end
end
