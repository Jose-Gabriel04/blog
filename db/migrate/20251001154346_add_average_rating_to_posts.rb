class AddAverageRatingToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :average_rating, :float, default: 0.0, null: false
    add_column :posts, :ratings_count, :integer, default: 0, null: false
  end
end