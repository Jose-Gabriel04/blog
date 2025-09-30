# frozen_string_literal: true

class PostSerializer
  def initialize(post)
    @post = post
  end

  def as_json
    attrs = %w[id title body created_at updated_at]

    result = @post.attributes.slice(*attrs.map(&:to_s))

    result[:user] = UserSerializer.new(@post.user).as_json

    result
  end
end
