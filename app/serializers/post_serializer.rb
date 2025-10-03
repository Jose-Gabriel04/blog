# frozen_string_literal: true

class PostSerializer
  def initialize(post, context: :post)
    @post = post
    @context = context
  end

  def as_json
    case @context
    when :post
      post
    when :top
      top
    when :shared_ips
      shared_ips
    end
  end

  private

  def post
    {
      id: @post.id,
      title: @post.title,
      body: @post.body,
      created_at: @post.created_at,
      updated_at: @post.updated_at,
      user: UserSerializer.new(@post.user).as_json
    }
  end

  def top
    {
      id: @post.id,
      body: @post.body,
      average_rating: @post.average_rating
    }
  end

  def shared_ips
    {
      ip: @post.ip,
      authors: @post.authors_logins
    }
  end
end
