# frozen_string_literal: true

class TopPostsQuery < BaseQuery
  MAX_LIMIT = 100

  def call
    Post.order(average_rating: :desc)
        .select('posts.id, posts.title, posts.body, posts.average_rating')
        .limit(limit)

    # Post.joins(:ratings)
    #     .group('posts.id')
    #     .order(avg_rating: :desc)
    #     .select('posts.id, posts.title, posts.body, AVG(ratings.value) AS average_rating')
    #     .limit(limit)
  end

  private

  def limit
    limit_i = @params[:limit].to_i

    return 5 unless limit_i.positive?

    [limit_i, MAX_LIMIT].min
  end
end
