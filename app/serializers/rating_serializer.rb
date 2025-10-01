# frozen_string_literal: true

class RatingSerializer
  def initialize(rating)
    @rating = rating
  end

  def as_json
    {
      id: @rating.id,
      average_rating: @rating.post.reload.average_rating
    }
  end
end
