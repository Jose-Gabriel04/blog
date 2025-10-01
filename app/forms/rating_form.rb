# frozen_string_literal: true

class RatingForm < BaseForm
  attribute :post_id, :integer
  attribute :user_id, :integer
  attribute :value, :integer

  validates :post_id, :user_id, :value, presence: true
  validates :value, inclusion: { in: 1..5 }, if: -> { value.present? }
  validate :post_exists
  validate :user_exists

  def save
    super

    increment_average_rating if errors.blank?
  rescue ActiveRecord::RecordNotUnique
    errors.add(:base, 'You have already rated this post')
    false
  end

  private

  def default_record
    Rating.new
  end

  def attributes_for_creation
    { post_id:, user_id:, value: }
  end

  def post_exists
    return if post_id.blank?

    @post = Post.find_by(id: post_id)
    errors.add(:post_id, 'not found') if @post.nil?
  end

  def user_exists
    return if user_id.blank?

    errors.add(:user_id, 'not found') unless User.exists?(id: user_id)
  end

  def increment_average_rating
    Post.where(id: post_id).update_all(<<~SQL.squish)
      average_rating = (
        (average_rating * ratings_count + #{value})::float
        / (ratings_count + 1)
      ),
      ratings_count = ratings_count + 1
    SQL
  end
end
