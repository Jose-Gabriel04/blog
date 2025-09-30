# frozen_string_literal: true

RSpec.describe PostSerializer do
  describe '#as_json' do
    subject(:serializer) { described_class.new(post) }

    let(:user) { create(:user, id: 1, login: 'john_doe') }
    let(:post) do
      create(:post, id: 1, title: 'Test Title', body: 'Test Body', user: user,
                    created_at: Time.zone.parse('2025-09-30 10:00:00 UTC'),
                    updated_at: Time.zone.parse('2025-09-30 11:00:00 UTC'))
    end

    it 'includes serialized post' do
      result = serializer.as_json

      expect(result['id']).to eq(1)
      expect(result['title']).to eq('Test Title')
      expect(result['body']).to eq('Test Body')
      expect(result['created_at']).to eq(post.created_at)
      expect(result['updated_at']).to eq(post.updated_at)
    end

    it 'includes serialized user' do
      result = serializer.as_json

      expect(result[:user]).to be_a(Hash)
      expect(result[:user][:id]).to eq(1)
      expect(result[:user][:login]).to eq('john_doe')
    end
  end
end
