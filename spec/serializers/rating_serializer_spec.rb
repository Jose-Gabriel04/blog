# frozen_string_literal: true

RSpec.describe RatingSerializer do
  describe '#as_json' do
    subject(:serializer) { described_class.new(rating) }

    let(:user) { create(:user) }
    let(:post) { create(:post, user:, average_rating: 5.0, ratings_count: 1) }
    let!(:rating) { create(:rating, id: 1, value: 5, post:, user:) }

    it 'includes serialized rating' do
      result = serializer.as_json

      expect(result[:id]).to eq(1)
      expect(result[:average_rating]).to eq(5.0)
    end
  end
end
