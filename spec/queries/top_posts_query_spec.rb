# frozen_string_literal: true

RSpec.describe TopPostsQuery do
  describe '#call' do
    subject(:query) { described_class.new({ limit: 2 }) }

    before do
      create(:post, id: 100, title: 'title_1', body: 'test_post_1', average_rating: 5.0)
      create(:post, id: 101, title: 'title_2', body: 'test_post_2', average_rating: 4.5)
      create(:post, id: 102, title: 'title_3', body: 'test_post_3', average_rating: 4.0)
      create(:post, id: 103, title: 'title_4', body: 'test_post_4', average_rating: 3.0)
      create(:post, id: 104, title: 'title_5', body: 'test_post_5', average_rating: 2.0)
    end

    it 'returns Posts ordered by average rating desc limited by params limit' do
      result = query.call

      expect(result).to be_a(ActiveRecord::Relation)
      expect(result.length).to eq(2)
      posts_data = result.map do |record|
        {
          'id' => record.id,
          'title' => record.title,
          'body' => record.body,
          'average_rating' => record.average_rating
        }
      end

      expect(posts_data)
        .to contain_exactly({ 'id' => 100, 'title' => 'title_1', 'body' => 'test_post_1',
                              'average_rating' => 5.0 },
                            { 'id' => 101, 'title' => 'title_2', 'body' => 'test_post_2',
                              'average_rating' => 4.5 })
    end

    context 'when params limit is negative' do
      subject(:query) { described_class.new }

      let(:response) do
        [
          { 'id' => 100, 'title' => 'title_1', 'body' => 'test_post_1', 'average_rating' => 5.0 },
          { 'id' => 101, 'title' => 'title_2', 'body' => 'test_post_2', 'average_rating' => 4.5 },
          { 'id' => 102, 'title' => 'title_3', 'body' => 'test_post_3', 'average_rating' => 4.0 },
          { 'id' => 103, 'title' => 'title_4', 'body' => 'test_post_4', 'average_rating' => 3.0 },
          { 'id' => 104, 'title' => 'title_5', 'body' => 'test_post_5', 'average_rating' => 2.0 }
        ]
      end

      it 'returns Posts ordered by average rating desc limited by 5' do
        result = query.call

        expect(result).to be_a(ActiveRecord::Relation)
        expect(result.length).to eq(5)
        posts_data = result.map do |record|
          {
            'id' => record.id,
            'title' => record.title,
            'body' => record.body,
            'average_rating' => record.average_rating
          }
        end

        expect(posts_data).to match_array(response)
      end
    end

    context 'when params limit is more than MAX_LIMIT' do
      subject(:query) { described_class.new({ limit: 3 }) }

      before { stub_const("#{described_class}::MAX_LIMIT", 2) }

      it 'returns Posts ordered by average rating desc limited by MAX_LIMIT' do
        result = query.call

        expect(result).to be_a(ActiveRecord::Relation)
        expect(result.length).to eq(2)
        posts_data = result.map do |record|
          {
            'id' => record.id,
            'title' => record.title,
            'body' => record.body,
            'average_rating' => record.average_rating
          }
        end

        expect(posts_data)
          .to contain_exactly({ 'id' => 100, 'title' => 'title_1', 'body' => 'test_post_1',
                                'average_rating' => 5.0 },
                              { 'id' => 101, 'title' => 'title_2', 'body' => 'test_post_2',
                                'average_rating' => 4.5 })
      end
    end
  end
end
